import { Injectable, ConflictException, BadRequestException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { StudentPanelAssignment, StudentPanelAssignmentDocument } from './schemas/student-panel-assignment.schema';
import { EvaluatorPanelAssignment, EvaluatorPanelAssignmentDocument, EvaluatorRole } from './schemas/evaluator-panel-assignment.schema';
import { PanelsService } from '../panels/panels.service';

export interface AssignStudentsToPanelDto {
  panelId: string;
  studentIds: string[];
  reviewPhaseId: string;
  scheduledDateTime?: Date;
}

export interface AssignEvaluatorsToPanelDto {
  panelId: string;
  reviewPhaseId: string;
  evaluators: Array<{
    evaluatorId: string;
    role: EvaluatorRole;
  }>;
}

export interface BulkAssignStudentsDto {
  reviewPhaseId: string;
  assignments: Array<{
    panelId: string;
    studentIds: string[];
  }>;
  distributionMethod?: 'manual' | 'auto-balance';
}

@Injectable()
export class AssignmentsService {
  constructor(
    @InjectModel(StudentPanelAssignment.name) 
    private studentAssignmentModel: Model<StudentPanelAssignmentDocument>,
    @InjectModel(EvaluatorPanelAssignment.name) 
    private evaluatorAssignmentModel: Model<EvaluatorPanelAssignmentDocument>,
    private panelsService: PanelsService,
  ) {}

  // Student Assignment Methods
  async assignStudentsToPanel(assignDto: AssignStudentsToPanelDto): Promise<{
    success: StudentPanelAssignment[];
    errors: Array<{ studentId: string; error: string }>;
  }> {
    const success: StudentPanelAssignment[] = [];
    const errors: Array<{ studentId: string; error: string }> = [];

    // Check panel capacity
    const panel = await this.panelsService.findOne(assignDto.panelId);
    if (!panel) {
      throw new BadRequestException('Panel not found');
    }

    if (panel.currentCount + assignDto.studentIds.length > panel.capacity) {
      throw new BadRequestException('Panel capacity exceeded');
    }

    for (const studentId of assignDto.studentIds) {
      try {
        const assignment = new this.studentAssignmentModel({
          studentId: new Types.ObjectId(studentId),
          panelId: new Types.ObjectId(assignDto.panelId),
          reviewPhaseId: new Types.ObjectId(assignDto.reviewPhaseId),
          scheduledDateTime: assignDto.scheduledDateTime,
        });

        const savedAssignment = await assignment.save();
        await this.panelsService.incrementStudentCount(assignDto.panelId);
        success.push(savedAssignment);
      } catch (error) {
        if (error.code === 11000) {
          errors.push({ studentId, error: 'Student already assigned to a panel for this review phase' });
        } else {
          errors.push({ studentId, error: error.message });
        }
      }
    }

    return { success, errors };
  }

  async bulkAssignStudents(bulkDto: BulkAssignStudentsDto): Promise<{
    totalAssigned: number;
    assignmentDetails: Array<{
      panelId: string;
      assigned: number;
      errors: number;
    }>;
  }> {
    let totalAssigned = 0;
    const assignmentDetails: Array<{
      panelId: string;
      assigned: number;
      errors: number;
    }> = [];

    for (const assignment of bulkDto.assignments) {
      const result = await this.assignStudentsToPanel({
        ...assignment,
        reviewPhaseId: bulkDto.reviewPhaseId,
      });

      assignmentDetails.push({
        panelId: assignment.panelId,
        assigned: result.success.length,
        errors: result.errors.length,
      });

      totalAssigned += result.success.length;
    }

    return { totalAssigned, assignmentDetails };
  }

  async autoDistributeStudents(
    reviewPhaseId: string,
    studentIds: string[]
  ): Promise<{
    distributionPlan: Array<{
      panelId: string;
      panelName: string;
      assignedStudents: string[];
    }>;
    executed: boolean;
  }> {
    const availablePanels = await this.panelsService.getAvailablePanels(reviewPhaseId);
    
    if (availablePanels.length === 0) {
      throw new BadRequestException('No available panels for this review phase');
    }

    // Simple round-robin distribution
    const distributionPlan: Array<{
      panelId: string;
      panelName: string;
      assignedStudents: string[];
    }> = [];
    let currentPanelIndex = 0;

    for (const panel of availablePanels) {
      distributionPlan.push({
        panelId: panel._id.toString(),
        panelName: panel.name,
        assignedStudents: [],
      });
    }

    for (const studentId of studentIds) {
      const targetPanel = distributionPlan[currentPanelIndex];
      const panel = availablePanels[currentPanelIndex];
      
      if (targetPanel.assignedStudents.length < panel.capacity - panel.currentCount) {
        targetPanel.assignedStudents.push(studentId);
      }
      
      currentPanelIndex = (currentPanelIndex + 1) % availablePanels.length;
    }

    return { distributionPlan, executed: false };
  }

  // Evaluator Assignment Methods
  async assignEvaluatorsToPanel(assignDto: AssignEvaluatorsToPanelDto): Promise<{
    success: EvaluatorPanelAssignment[];
    errors: Array<{ evaluatorId: string; role: string; error: string }>;
  }> {
    const success: EvaluatorPanelAssignment[] = [];
    const errors: Array<{ evaluatorId: string; role: string; error: string }> = [];

    for (const evaluatorData of assignDto.evaluators) {
      try {
        const assignment = new this.evaluatorAssignmentModel({
          evaluatorId: new Types.ObjectId(evaluatorData.evaluatorId),
          panelId: new Types.ObjectId(assignDto.panelId),
          reviewPhaseId: new Types.ObjectId(assignDto.reviewPhaseId),
          roleInPanel: evaluatorData.role,
        });

        const savedAssignment = await assignment.save();
        success.push(savedAssignment);
      } catch (error) {
        if (error.code === 11000) {
          errors.push({ 
            evaluatorId: evaluatorData.evaluatorId, 
            role: evaluatorData.role,
            error: 'Evaluator already assigned to this panel' 
          });
        } else {
          errors.push({ 
            evaluatorId: evaluatorData.evaluatorId, 
            role: evaluatorData.role,
            error: error.message 
          });
        }
      }
    }

    return { success, errors };
  }

  // Query Methods
  async getStudentAssignments(
    reviewPhaseId: string,
    studentId?: string
  ): Promise<StudentPanelAssignment[]> {
    const query: any = { 
      reviewPhaseId: new Types.ObjectId(reviewPhaseId),
      isActive: true 
    };
    
    if (studentId) {
      query.studentId = new Types.ObjectId(studentId);
    }

    return this.studentAssignmentModel
      .find(query)
      .populate('studentId', 'registerNo name projectTitle')
      .populate('panelId', 'name location coordinatorId')
      .populate('reviewPhaseId', 'name order')
      .sort({ 'panelId.name': 1 })
      .exec();
  }

  async getEvaluatorAssignments(
    reviewPhaseId: string,
    evaluatorId?: string
  ): Promise<EvaluatorPanelAssignment[]> {
    const query: any = { 
      reviewPhaseId: new Types.ObjectId(reviewPhaseId),
      isActive: true 
    };
    
    if (evaluatorId) {
      query.evaluatorId = new Types.ObjectId(evaluatorId);
    }

    return this.evaluatorAssignmentModel
      .find(query)
      .populate('evaluatorId', 'name email department')
      .populate('panelId', 'name location coordinatorId')
      .populate('reviewPhaseId', 'name order')
      .sort({ 'panelId.name': 1, roleInPanel: 1 })
      .exec();
  }

  async getPanelAssignments(panelId: string): Promise<{
    students: StudentPanelAssignment[];
    evaluators: EvaluatorPanelAssignment[];
  }> {
    const [students, evaluators] = await Promise.all([
      this.studentAssignmentModel
        .find({ panelId: new Types.ObjectId(panelId), isActive: true })
        .populate('studentId', 'registerNo name projectTitle supervisor')
        .sort({ 'studentId.registerNo': 1 })
        .exec(),
      this.evaluatorAssignmentModel
        .find({ panelId: new Types.ObjectId(panelId), isActive: true })
        .populate('evaluatorId', 'name email department')
        .sort({ roleInPanel: 1 })
        .exec(),
    ]);

    return { students, evaluators };
  }

  // Removal Methods
  async removeStudentAssignment(assignmentId: string): Promise<StudentPanelAssignment | null> {
    const assignment = await this.studentAssignmentModel.findById(assignmentId);
    if (assignment) {
      await this.panelsService.decrementStudentCount(assignment.panelId.toString());
    }

    return this.studentAssignmentModel
      .findByIdAndUpdate(
        assignmentId,
        { isActive: false, updatedAt: new Date() },
        { new: true }
      )
      .exec();
  }

  async removeEvaluatorAssignment(assignmentId: string): Promise<EvaluatorPanelAssignment | null> {
    return this.evaluatorAssignmentModel
      .findByIdAndUpdate(
        assignmentId,
        { isActive: false, updatedAt: new Date() },
        { new: true }
      )
      .exec();
  }

  // Statistics
  async getAssignmentStats(reviewPhaseId: string): Promise<{
    totalStudents: number;
    assignedStudents: number;
    unassignedStudents: number;
    totalEvaluators: number;
    assignedEvaluators: number;
    panelUtilization: Array<{
      panelId: string;
      panelName: string;
      capacity: number;
      assigned: number;
      utilizationRate: number;
    }>;
  }> {
    const [studentAssignments, evaluatorAssignments, panels] = await Promise.all([
      this.studentAssignmentModel.countDocuments({ 
        reviewPhaseId: new Types.ObjectId(reviewPhaseId), 
        isActive: true 
      }),
      this.evaluatorAssignmentModel.countDocuments({ 
        reviewPhaseId: new Types.ObjectId(reviewPhaseId), 
        isActive: true 
      }),
      this.panelsService.findByReviewPhase(reviewPhaseId),
    ]);

    const panelUtilization = panels.map(panel => ({
      panelId: panel._id.toString(),
      panelName: panel.name,
      capacity: panel.capacity,
      assigned: panel.currentCount,
      utilizationRate: panel.capacity > 0 ? (panel.currentCount / panel.capacity) * 100 : 0,
    }));

    return {
      totalStudents: 0, // Would need to query students collection
      assignedStudents: studentAssignments,
      unassignedStudents: 0, // totalStudents - assignedStudents
      totalEvaluators: 0, // Would need to query users collection
      assignedEvaluators: evaluatorAssignments,
      panelUtilization,
    };
  }
}