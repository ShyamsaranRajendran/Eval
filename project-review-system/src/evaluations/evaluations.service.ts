import { Injectable, BadRequestException, ForbiddenException, ConflictException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Evaluation, EvaluationDocument } from './schemas/evaluation.schema';

export interface SubmitEvaluationDto {
  reviewPhaseId: string;
  panelId: string;
  studentId: string;
  criteriaId: string;
  marksAwarded: number;
  comments?: string;
}

export interface BulkSubmitEvaluationDto {
  reviewPhaseId: string;
  panelId: string;
  evaluations: Array<{
    studentId: string;
    criteriaId: string;
    marksAwarded: number;
    comments?: string;
  }>;
}

export interface UpdateEvaluationDto {
  marksAwarded?: number;
  comments?: string;
}

@Injectable()
export class EvaluationsService {
  constructor(
    @InjectModel(Evaluation.name) private evaluationModel: Model<EvaluationDocument>,
  ) {}

  async submitEvaluation(
    evaluatorId: string,
    submitDto: SubmitEvaluationDto,
  ): Promise<Evaluation> {
    // Validate marks are within criteria limits
    // This should be done by checking against EvaluationCriteria model
    // For now, we'll assume basic validation

    if (submitDto.marksAwarded < 0) {
      throw new BadRequestException('Marks cannot be negative');
    }

    const evaluationData = {
      ...submitDto,
      evaluatorId: new Types.ObjectId(evaluatorId),
      reviewPhaseId: new Types.ObjectId(submitDto.reviewPhaseId),
      panelId: new Types.ObjectId(submitDto.panelId),
      studentId: new Types.ObjectId(submitDto.studentId),
      criteriaId: new Types.ObjectId(submitDto.criteriaId),
    };

    try {
      const evaluation = new this.evaluationModel(evaluationData);
      return await evaluation.save();
    } catch (error) {
      if (error.code === 11000) { // Duplicate key error
        throw new ConflictException('Evaluation already exists for this student and criteria');
      }
      throw error;
    }
  }

  async bulkSubmitEvaluations(
    evaluatorId: string,
    bulkDto: BulkSubmitEvaluationDto,
  ): Promise<{
    success: Evaluation[];
    errors: Array<{ studentId: string; criteriaId: string; error: string }>;
  }> {
    const success: Evaluation[] = [];
    const errors: Array<{ studentId: string; criteriaId: string; error: string }> = [];

    for (const evalData of bulkDto.evaluations) {
      try {
        const evaluation = await this.submitEvaluation(evaluatorId, {
          ...bulkDto,
          ...evalData,
        });
        success.push(evaluation);
      } catch (error) {
        errors.push({
          studentId: evalData.studentId,
          criteriaId: evalData.criteriaId,
          error: error.message,
        });
      }
    }

    return { success, errors };
  }

  async findEvaluationsByPanel(panelId: string): Promise<Evaluation[]> {
    return this.evaluationModel
      .find({ panelId: new Types.ObjectId(panelId) })
      .populate('evaluatorId', 'name email')
      .populate('studentId', 'registerNo name projectTitle')
      .populate('criteriaId', 'name maxMarks')
      .sort({ studentId: 1, criteriaId: 1 })
      .exec();
  }

  async findEvaluationsByStudent(
    studentId: string,
    reviewPhaseId?: string,
  ): Promise<Evaluation[]> {
    const query: any = { studentId: new Types.ObjectId(studentId) };
    if (reviewPhaseId) {
      query.reviewPhaseId = new Types.ObjectId(reviewPhaseId);
    }

    return this.evaluationModel
      .find(query)
      .populate('evaluatorId', 'name email')
      .populate('criteriaId', 'name maxMarks order')
      .populate('reviewPhaseId', 'name order')
      .sort({ reviewPhaseId: 1, criteriaId: 1 })
      .exec();
  }

  async getMyAssignments(
    evaluatorId: string,
    reviewPhaseId: string,
  ): Promise<{
    panelId: string;
    students: Array<{
      studentId: string;
      registerNo: string;
      name: string;
      projectTitle: string;
      evaluations: Array<{
        criteriaId: string;
        criteriaName: string;
        maxMarks: number;
        marksAwarded?: number;
        comments?: string;
        isEvaluated: boolean;
      }>;
      totalMarks: number;
      maxTotalMarks: number;
    }>;
  }[]> {
    // This is a complex query that would need to aggregate data from multiple collections
    // Implementation would involve finding assigned panels and students, then their evaluations
    // For now, returning a basic structure
    return [];
  }

  async getEvaluationProgress(panelId: string): Promise<{
    totalStudents: number;
    totalCriteria: number;
    totalEvaluations: number;
    completedEvaluations: number;
    progressPercentage: number;
    evaluatorProgress: Array<{
      evaluatorId: string;
      evaluatorName: string;
      completed: number;
      total: number;
      percentage: number;
    }>;
  }> {
    // Complex aggregation query to calculate progress
    // This would involve counting assigned students, criteria, and completed evaluations
    return {
      totalStudents: 0,
      totalCriteria: 0,
      totalEvaluations: 0,
      completedEvaluations: 0,
      progressPercentage: 0,
      evaluatorProgress: [],
    };
  }

  async updateEvaluation(
    id: string,
    evaluatorId: string,
    updateDto: UpdateEvaluationDto,
  ): Promise<Evaluation | null> {
    // Check if evaluation belongs to the evaluator and is not finalized
    const evaluation = await this.evaluationModel.findOne({
      _id: id,
      evaluatorId: new Types.ObjectId(evaluatorId),
    });

    if (!evaluation) {
      throw new ForbiddenException('Evaluation not found or not accessible');
    }

    if (evaluation.isFinalized) {
      throw new BadRequestException('Cannot update finalized evaluation');
    }

    return this.evaluationModel
      .findByIdAndUpdate(
        id,
        { ...updateDto, updatedAt: new Date() },
        { new: true },
      )
      .populate('evaluatorId', 'name email')
      .populate('studentId', 'registerNo name')
      .populate('criteriaId', 'name maxMarks')
      .exec();
  }

  async finalizeEvaluations(
    panelId: string,
    evaluatorId: string,
  ): Promise<{ finalizedCount: number }> {
    const result = await this.evaluationModel.updateMany(
      {
        panelId: new Types.ObjectId(panelId),
        evaluatorId: new Types.ObjectId(evaluatorId),
        isFinalized: false,
      },
      {
        isFinalized: true,
        updatedAt: new Date(),
      },
    );

    return { finalizedCount: result.modifiedCount };
  }

  async getStudentScoreCard(
    studentId: string,
    reviewPhaseId: string,
  ): Promise<{
    studentInfo: any;
    totalScore: number;
    maxTotalScore: number;
    percentage: number;
    criteriaWiseScores: Array<{
      criteriaName: string;
      maxMarks: number;
      averageMarks: number;
      evaluatorScores: Array<{
        evaluatorName: string;
        marksAwarded: number;
        comments?: string;
      }>;
    }>;
  }> {
    // Complex aggregation to calculate average scores per criteria
    // and compile complete score card
    return {
      studentInfo: {},
      totalScore: 0,
      maxTotalScore: 0,
      percentage: 0,
      criteriaWiseScores: [],
    };
  }

  async deleteEvaluation(
    id: string,
    evaluatorId: string,
  ): Promise<Evaluation | null> {
    const evaluation = await this.evaluationModel.findOne({
      _id: id,
      evaluatorId: new Types.ObjectId(evaluatorId),
    });

    if (!evaluation) {
      throw new ForbiddenException('Evaluation not found or not accessible');
    }

    if (evaluation.isFinalized) {
      throw new BadRequestException('Cannot delete finalized evaluation');
    }

    return this.evaluationModel.findByIdAndDelete(id).exec();
  }
}