import { Controller, Get, Post, Put, Delete, Param, Body, UseGuards } from '@nestjs/common';
import { EvaluationCriteriaService } from './evaluation-criteria.service';
import type { CreateEvaluationCriteriaDto, UpdateEvaluationCriteriaDto, BulkCreateCriteriaDto } from './evaluation-criteria.service';
import { EvaluationCriteria } from './schemas/evaluation-criteria.schema';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';
import { UserRole } from '../users/schemas/user.schema';

@Controller('evaluation-criteria')
@UseGuards(JwtAuthGuard, RolesGuard)
export class EvaluationCriteriaController {
  constructor(private readonly evaluationCriteriaService: EvaluationCriteriaService) {}

  @Post()
  @Roles(UserRole.ADMIN)
  async create(@Body() createDto: CreateEvaluationCriteriaDto): Promise<EvaluationCriteria> {
    return this.evaluationCriteriaService.create(createDto);
  }

  @Post('bulk')
  @Roles(UserRole.ADMIN)
  async bulkCreate(@Body() bulkDto: BulkCreateCriteriaDto): Promise<EvaluationCriteria[]> {
    return this.evaluationCriteriaService.bulkCreate(bulkDto);
  }

  @Get()
  async findAll(): Promise<EvaluationCriteria[]> {
    return this.evaluationCriteriaService.findAll();
  }

  @Get('review-phase/:phaseId')
  async findByReviewPhase(@Param('phaseId') phaseId: string): Promise<EvaluationCriteria[]> {
    return this.evaluationCriteriaService.findByReviewPhase(phaseId);
  }

  @Get('review-phase/:phaseId/total-marks')
  async getTotalMaxMarks(@Param('phaseId') phaseId: string): Promise<{ totalMaxMarks: number }> {
    const total = await this.evaluationCriteriaService.getTotalMaxMarks(phaseId);
    return { totalMaxMarks: total };
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<EvaluationCriteria | null> {
    return this.evaluationCriteriaService.findOne(id);
  }

  @Put('review-phase/:phaseId/reorder')
  @Roles(UserRole.ADMIN)
  async reorderCriteria(
    @Param('phaseId') phaseId: string,
    @Body() body: { criteriaIds: string[] }
  ): Promise<EvaluationCriteria[]> {
    return this.evaluationCriteriaService.reorderCriteria(phaseId, body.criteriaIds);
  }

  @Put(':id')
  @Roles(UserRole.ADMIN)
  async update(
    @Param('id') id: string,
    @Body() updateDto: UpdateEvaluationCriteriaDto,
  ): Promise<EvaluationCriteria | null> {
    return this.evaluationCriteriaService.update(id, updateDto);
  }

  @Delete(':id')
  @Roles(UserRole.ADMIN)
  async remove(@Param('id') id: string): Promise<EvaluationCriteria | null> {
    return this.evaluationCriteriaService.remove(id);
  }
}