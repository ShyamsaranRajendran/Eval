import { Injectable, ConflictException, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { ReviewPhase, ReviewPhaseDocument } from './schemas/review-phase.schema';

export interface CreateReviewPhaseDto {
  name: string;
  order: number;
  academicYear: string;
  startDate?: Date;
  endDate?: Date;
  description?: string;
}

export interface UpdateReviewPhaseDto {
  name?: string;
  startDate?: Date;
  endDate?: Date;
  description?: string;
}

@Injectable()
export class ReviewPhasesService {
  constructor(
    @InjectModel(ReviewPhase.name) private reviewPhaseModel: Model<ReviewPhaseDocument>,
  ) {}

  async create(createReviewPhaseDto: CreateReviewPhaseDto): Promise<ReviewPhase> {
    // Check if phase order already exists for this academic year
    const existingPhase = await this.reviewPhaseModel.findOne({
      order: createReviewPhaseDto.order,
      academicYear: createReviewPhaseDto.academicYear,
    });

    if (existingPhase) {
      throw new ConflictException(
        `Review phase with order ${createReviewPhaseDto.order} already exists for ${createReviewPhaseDto.academicYear}`,
      );
    }

    const createdPhase = new this.reviewPhaseModel(createReviewPhaseDto);
    return createdPhase.save();
  }

  async findAll(): Promise<ReviewPhase[]> {
    return this.reviewPhaseModel.find().sort({ academicYear: -1, order: 1 }).exec();
  }

  async findByAcademicYear(academicYear: string): Promise<ReviewPhase[]> {
    return this.reviewPhaseModel
      .find({ academicYear })
      .sort({ order: 1 })
      .exec();
  }

  async findOne(id: string): Promise<ReviewPhase | null> {
    return this.reviewPhaseModel.findById(id).exec();
  }

  async getActivePhase(): Promise<ReviewPhase | null> {
    return this.reviewPhaseModel.findOne({ isActive: true }).exec();
  }

  async setActive(id: string): Promise<ReviewPhase> {
    // First, deactivate all phases
    await this.reviewPhaseModel.updateMany({}, { isActive: false, updatedAt: new Date() });

    // Then activate the specified phase
    const updatedPhase = await this.reviewPhaseModel.findByIdAndUpdate(
      id,
      { isActive: true, updatedAt: new Date() },
      { new: true },
    );

    if (!updatedPhase) {
      throw new NotFoundException('Review phase not found');
    }

    return updatedPhase;
  }

  async update(id: string, updateReviewPhaseDto: UpdateReviewPhaseDto): Promise<ReviewPhase | null> {
    return this.reviewPhaseModel
      .findByIdAndUpdate(
        id,
        { ...updateReviewPhaseDto, updatedAt: new Date() },
        { new: true },
      )
      .exec();
  }

  async remove(id: string): Promise<ReviewPhase | null> {
    // Check if phase has any evaluations before deletion
    // This would require checking the evaluations collection
    // For now, we'll just delete the phase
    return this.reviewPhaseModel.findByIdAndDelete(id).exec();
  }

  async getCurrentAcademicYear(): Promise<string> {
    const currentDate = new Date();
    const currentYear = currentDate.getFullYear();
    const currentMonth = currentDate.getMonth() + 1; // getMonth() returns 0-11
    
    // Academic year typically starts in July/August
    if (currentMonth >= 7) {
      return `${currentYear}-${currentYear + 1}`;
    } else {
      return `${currentYear - 1}-${currentYear}`;
    }
  }
}