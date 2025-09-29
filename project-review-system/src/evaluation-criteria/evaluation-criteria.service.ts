import { Injectable, ConflictException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { EvaluationCriteria, EvaluationCriteriaDocument } from './schemas/evaluation-criteria.schema';

export interface CreateEvaluationCriteriaDto {
  reviewPhaseId: string;
  name: string;
  description?: string;
  maxMarks: number;
  weightage?: number;
  order: number;
}

export interface UpdateEvaluationCriteriaDto {
  name?: string;
  description?: string;
  maxMarks?: number;
  weightage?: number;
  order?: number;
  isActive?: boolean;
}

export interface BulkCreateCriteriaDto {
  reviewPhaseId: string;
  criteria: Array<{
    name: string;
    description?: string;
    maxMarks: number;
    weightage?: number;
    order: number;
  }>;
}

@Injectable()
export class EvaluationCriteriaService {
  constructor(
    @InjectModel(EvaluationCriteria.name) 
    private evaluationCriteriaModel: Model<EvaluationCriteriaDocument>,
  ) {}

  async create(createDto: CreateEvaluationCriteriaDto): Promise<EvaluationCriteria> {
    // Check if criteria order already exists for this review phase
    const existingCriteria = await this.evaluationCriteriaModel.findOne({
      reviewPhaseId: new Types.ObjectId(createDto.reviewPhaseId),
      order: createDto.order,
    });

    if (existingCriteria) {
      throw new ConflictException(
        `Criteria with order ${createDto.order} already exists for this review phase`,
      );
    }

    const createdCriteria = new this.evaluationCriteriaModel({
      ...createDto,
      reviewPhaseId: new Types.ObjectId(createDto.reviewPhaseId),
    });
    return createdCriteria.save();
  }

  async bulkCreate(bulkDto: BulkCreateCriteriaDto): Promise<EvaluationCriteria[]> {
    // First, deactivate existing criteria for this review phase
    await this.evaluationCriteriaModel.updateMany(
      { reviewPhaseId: new Types.ObjectId(bulkDto.reviewPhaseId) },
      { isActive: false, updatedAt: new Date() },
    );

    // Create new criteria
    const criteriaPromises = bulkDto.criteria.map(criteria =>
      this.evaluationCriteriaModel.create({
        ...criteria,
        reviewPhaseId: new Types.ObjectId(bulkDto.reviewPhaseId),
      }),
    );

    return Promise.all(criteriaPromises);
  }

  async findAll(): Promise<EvaluationCriteria[]> {
    return this.evaluationCriteriaModel
      .find({ isActive: true })
      .populate('reviewPhaseId', 'name order academicYear')
      .sort({ order: 1 })
      .exec();
  }

  async findByReviewPhase(reviewPhaseId: string): Promise<EvaluationCriteria[]> {
    return this.evaluationCriteriaModel
      .find({
        reviewPhaseId: new Types.ObjectId(reviewPhaseId),
        isActive: true,
      })
      .sort({ order: 1 })
      .exec();
  }

  async findOne(id: string): Promise<EvaluationCriteria | null> {
    return this.evaluationCriteriaModel
      .findById(id)
      .populate('reviewPhaseId', 'name order academicYear')
      .exec();
  }

  async update(id: string, updateDto: UpdateEvaluationCriteriaDto): Promise<EvaluationCriteria | null> {
    // If order is being updated, check for conflicts
    if (updateDto.order) {
      const criteria = await this.evaluationCriteriaModel.findById(id);
      if (criteria) {
        const existingWithOrder = await this.evaluationCriteriaModel.findOne({
          reviewPhaseId: criteria.reviewPhaseId,
          order: updateDto.order,
          _id: { $ne: id },
        });

        if (existingWithOrder) {
          throw new ConflictException(
            `Criteria with order ${updateDto.order} already exists for this review phase`,
          );
        }
      }
    }

    return this.evaluationCriteriaModel
      .findByIdAndUpdate(
        id,
        { ...updateDto, updatedAt: new Date() },
        { new: true },
      )
      .exec();
  }

  async remove(id: string): Promise<EvaluationCriteria | null> {
    // Soft delete by setting isActive to false
    return this.evaluationCriteriaModel
      .findByIdAndUpdate(
        id,
        { isActive: false, updatedAt: new Date() },
        { new: true },
      )
      .exec();
  }

  async getTotalMaxMarks(reviewPhaseId: string): Promise<number> {
    const criteria = await this.findByReviewPhase(reviewPhaseId);
    return criteria.reduce((total, criterion) => total + criterion.maxMarks, 0);
  }

  async reorderCriteria(reviewPhaseId: string, newOrder: string[]): Promise<EvaluationCriteria[]> {
    const updatePromises = newOrder.map((criteriaId, index) =>
      this.evaluationCriteriaModel.findByIdAndUpdate(
        criteriaId,
        { order: index + 1, updatedAt: new Date() },
        { new: true },
      ),
    );

    const updatedCriteria = await Promise.all(updatePromises);
    return updatedCriteria
      .filter(c => c !== null)
      .map(c => (c as any).toObject());
  }
}