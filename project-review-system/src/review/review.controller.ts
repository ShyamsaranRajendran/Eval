import { Controller, Get, Post, Put, Delete, Param, Body } from '@nestjs/common';
import { ReviewService } from './review.service';
import { Review } from './schemas/review.schema';

@Controller('reviews')
export class ReviewController {
  constructor(private readonly reviewService: ReviewService) {}

  @Post()
  async create(@Body() createReviewDto: any): Promise<Review> {
    return this.reviewService.create(createReviewDto);
  }

  @Get()
  async findAll(): Promise<Review[]> {
    return this.reviewService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<Review | null> {
    return this.reviewService.findOne(id);
  }

  @Get('project/:projectId')
  async findByProject(@Param('projectId') projectId: string): Promise<Review[]> {
    return this.reviewService.findByProject(projectId);
  }

  @Get('project/:projectId/review/:reviewNumber')
  async findByProjectAndReviewNumber(
    @Param('projectId') projectId: string,
    @Param('reviewNumber') reviewNumber: string
  ): Promise<Review | null> {
    return this.reviewService.findByProjectAndReviewNumber(projectId, parseInt(reviewNumber));
  }

  @Put(':id/marks')
  async addMarks(
    @Param('id') id: string,
    @Body() marksData: {
      studentId: string;
      reviewerId: string;
      criteriaName: string;
      marksObtained: number;
    }
  ): Promise<Review | null> {
    return this.reviewService.addMarks(id, marksData);
  }

  @Put(':id/comments')
  async addComment(
    @Param('id') id: string,
    @Body() commentData: {
      reviewerId: string;
      comment: string;
    }
  ): Promise<Review | null> {
    return this.reviewService.addComment(id, commentData);
  }

  @Get(':id/total-score')
  async calculateTotalScore(@Param('id') id: string): Promise<{ totalScore: number }> {
    const totalScore = await this.reviewService.calculateTotalScore(id);
    return { totalScore };
  }

  @Put(':id')
  async update(@Param('id') id: string, @Body() updateReviewDto: any): Promise<Review | null> {
    return this.reviewService.update(id, updateReviewDto);
  }

  @Delete(':id')
  async remove(@Param('id') id: string): Promise<Review | null> {
    return this.reviewService.remove(id);
  }
}