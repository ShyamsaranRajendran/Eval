import { Controller, Get, Post, Put, Delete, Param, Body, UseGuards } from '@nestjs/common';
import { ReviewPhasesService } from './review-phases.service';
import type { CreateReviewPhaseDto, UpdateReviewPhaseDto } from './review-phases.service';
import { ReviewPhase } from './schemas/review-phase.schema';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';
import { UserRole } from '../users/schemas/user.schema';

@Controller('review-phases')
@UseGuards(JwtAuthGuard, RolesGuard)
export class ReviewPhasesController {
  constructor(private readonly reviewPhasesService: ReviewPhasesService) {}

  @Post()
  @Roles(UserRole.ADMIN)
  async create(@Body() createReviewPhaseDto: CreateReviewPhaseDto): Promise<ReviewPhase> {
    return this.reviewPhasesService.create(createReviewPhaseDto);
  }

  @Get()
  async findAll(): Promise<ReviewPhase[]> {
    return this.reviewPhasesService.findAll();
  }

  @Get('active')
  async getActivePhase(): Promise<ReviewPhase | null> {
    return this.reviewPhasesService.getActivePhase();
  }

  @Get('academic-year/:year')
  async findByAcademicYear(@Param('year') year: string): Promise<ReviewPhase[]> {
    return this.reviewPhasesService.findByAcademicYear(year);
  }

  @Get('current-academic-year')
  async getCurrentAcademicYear(): Promise<{ academicYear: string }> {
    const academicYear = await this.reviewPhasesService.getCurrentAcademicYear();
    return { academicYear };
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<ReviewPhase | null> {
    return this.reviewPhasesService.findOne(id);
  }

  @Put(':id/activate')
  @Roles(UserRole.ADMIN)
  async setActive(@Param('id') id: string): Promise<ReviewPhase> {
    return this.reviewPhasesService.setActive(id);
  }

  @Put(':id')
  @Roles(UserRole.ADMIN)
  async update(
    @Param('id') id: string,
    @Body() updateReviewPhaseDto: UpdateReviewPhaseDto,
  ): Promise<ReviewPhase | null> {
    return this.reviewPhasesService.update(id, updateReviewPhaseDto);
  }

  @Delete(':id')
  @Roles(UserRole.ADMIN)
  async remove(@Param('id') id: string): Promise<ReviewPhase | null> {
    return this.reviewPhasesService.remove(id);
  }
}