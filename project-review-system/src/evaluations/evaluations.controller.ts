import { Controller, Get, Post, Put, Delete, Param, Body, Query, UseGuards, Request } from '@nestjs/common';
import { EvaluationsService } from './evaluations.service';
import type { SubmitEvaluationDto, BulkSubmitEvaluationDto, UpdateEvaluationDto } from './evaluations.service';
import { Evaluation } from './schemas/evaluation.schema';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';
import { UserRole } from '../users/schemas/user.schema';

@Controller('evaluations')
@UseGuards(JwtAuthGuard, RolesGuard)
export class EvaluationsController {
  constructor(private readonly evaluationsService: EvaluationsService) {}

  @Post('submit')
  @Roles(UserRole.FACULTY)
  async submitEvaluation(
    @Request() req,
    @Body() submitDto: SubmitEvaluationDto,
  ): Promise<Evaluation> {
    return this.evaluationsService.submitEvaluation(req.user.id, submitDto);
  }

  @Post('bulk-submit')
  @Roles(UserRole.FACULTY)
  async bulkSubmitEvaluations(
    @Request() req,
    @Body() bulkDto: BulkSubmitEvaluationDto,
  ): Promise<{
    success: Evaluation[];
    errors: Array<{ studentId: string; criteriaId: string; error: string }>;
  }> {
    return this.evaluationsService.bulkSubmitEvaluations(req.user.id, bulkDto);
  }

  @Get('panel/:panelId')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR, UserRole.FACULTY)
  async findEvaluationsByPanel(@Param('panelId') panelId: string): Promise<Evaluation[]> {
    return this.evaluationsService.findEvaluationsByPanel(panelId);
  }

  @Get('student/:studentId')
  async findEvaluationsByStudent(
    @Param('studentId') studentId: string,
    @Query('reviewPhaseId') reviewPhaseId?: string,
  ): Promise<Evaluation[]> {
    return this.evaluationsService.findEvaluationsByStudent(studentId, reviewPhaseId);
  }

  @Get('my-assignments/:reviewPhaseId')
  @Roles(UserRole.FACULTY)
  async getMyAssignments(
    @Request() req,
    @Param('reviewPhaseId') reviewPhaseId: string,
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
    return this.evaluationsService.getMyAssignments(req.user.id, reviewPhaseId);
  }

  @Get('progress/:panelId')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async getEvaluationProgress(@Param('panelId') panelId: string): Promise<{
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
    return this.evaluationsService.getEvaluationProgress(panelId);
  }

  @Get('scorecard/:studentId/:reviewPhaseId')
  async getStudentScoreCard(
    @Param('studentId') studentId: string,
    @Param('reviewPhaseId') reviewPhaseId: string,
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
    return this.evaluationsService.getStudentScoreCard(studentId, reviewPhaseId);
  }

  @Put(':id')
  @Roles(UserRole.FACULTY)
  async updateEvaluation(
    @Request() req,
    @Param('id') id: string,
    @Body() updateDto: UpdateEvaluationDto,
  ): Promise<Evaluation | null> {
    return this.evaluationsService.updateEvaluation(id, req.user.id, updateDto);
  }

  @Post('finalize/:panelId')
  @Roles(UserRole.FACULTY)
  async finalizeEvaluations(
    @Request() req,
    @Param('panelId') panelId: string,
  ): Promise<{ finalizedCount: number }> {
    return this.evaluationsService.finalizeEvaluations(panelId, req.user.id);
  }

  @Delete(':id')
  @Roles(UserRole.FACULTY)
  async deleteEvaluation(
    @Request() req,
    @Param('id') id: string,
  ): Promise<Evaluation | null> {
    return this.evaluationsService.deleteEvaluation(id, req.user.id);
  }
}