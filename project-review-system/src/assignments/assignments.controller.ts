import { Controller, Get, Post, Delete, Param, Body, Query, UseGuards } from '@nestjs/common';
import { AssignmentsService } from './assignments.service';
import type { 
  AssignStudentsToPanelDto, 
  AssignEvaluatorsToPanelDto, 
  BulkAssignStudentsDto 
} from './assignments.service';
import { StudentPanelAssignment } from './schemas/student-panel-assignment.schema';
import { EvaluatorPanelAssignment } from './schemas/evaluator-panel-assignment.schema';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';
import { UserRole } from '../users/schemas/user.schema';

@Controller('assignments')
@UseGuards(JwtAuthGuard, RolesGuard)
export class AssignmentsController {
  constructor(private readonly assignmentsService: AssignmentsService) {}

  // Student Assignment Endpoints
  @Post('students')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async assignStudentsToPanel(@Body() assignDto: AssignStudentsToPanelDto): Promise<{
    success: StudentPanelAssignment[];
    errors: Array<{ studentId: string; error: string }>;
  }> {
    return this.assignmentsService.assignStudentsToPanel(assignDto);
  }

  @Post('students/bulk')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async bulkAssignStudents(@Body() bulkDto: BulkAssignStudentsDto): Promise<{
    totalAssigned: number;
    assignmentDetails: Array<{
      panelId: string;
      assigned: number;
      errors: number;
    }>;
  }> {
    return this.assignmentsService.bulkAssignStudents(bulkDto);
  }

  @Post('students/auto-distribute/:reviewPhaseId')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async autoDistributeStudents(
    @Param('reviewPhaseId') reviewPhaseId: string,
    @Body() body: { studentIds: string[] }
  ): Promise<{
    distributionPlan: Array<{
      panelId: string;
      panelName: string;
      assignedStudents: string[];
    }>;
    executed: boolean;
  }> {
    return this.assignmentsService.autoDistributeStudents(reviewPhaseId, body.studentIds);
  }

  // Evaluator Assignment Endpoints
  @Post('evaluators')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async assignEvaluatorsToPanel(@Body() assignDto: AssignEvaluatorsToPanelDto): Promise<{
    success: EvaluatorPanelAssignment[];
    errors: Array<{ evaluatorId: string; role: string; error: string }>;
  }> {
    return this.assignmentsService.assignEvaluatorsToPanel(assignDto);
  }

  // Query Endpoints
  @Get('students/:reviewPhaseId')
  async getStudentAssignments(
    @Param('reviewPhaseId') reviewPhaseId: string,
    @Query('studentId') studentId?: string
  ): Promise<StudentPanelAssignment[]> {
    return this.assignmentsService.getStudentAssignments(reviewPhaseId, studentId);
  }

  @Get('evaluators/:reviewPhaseId')
  async getEvaluatorAssignments(
    @Param('reviewPhaseId') reviewPhaseId: string,
    @Query('evaluatorId') evaluatorId?: string
  ): Promise<EvaluatorPanelAssignment[]> {
    return this.assignmentsService.getEvaluatorAssignments(reviewPhaseId, evaluatorId);
  }

  @Get('panel/:panelId')
  async getPanelAssignments(@Param('panelId') panelId: string): Promise<{
    students: StudentPanelAssignment[];
    evaluators: EvaluatorPanelAssignment[];
  }> {
    return this.assignmentsService.getPanelAssignments(panelId);
  }

  @Get('stats/:reviewPhaseId')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async getAssignmentStats(@Param('reviewPhaseId') reviewPhaseId: string): Promise<{
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
    return this.assignmentsService.getAssignmentStats(reviewPhaseId);
  }

  // Removal Endpoints
  @Delete('students/:assignmentId')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async removeStudentAssignment(@Param('assignmentId') assignmentId: string): Promise<StudentPanelAssignment | null> {
    return this.assignmentsService.removeStudentAssignment(assignmentId);
  }

  @Delete('evaluators/:assignmentId')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async removeEvaluatorAssignment(@Param('assignmentId') assignmentId: string): Promise<EvaluatorPanelAssignment | null> {
    return this.assignmentsService.removeEvaluatorAssignment(assignmentId);
  }
}