import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Review, ReviewDocument } from './schemas/review.schema';

@Injectable()
export class ReviewService {
  constructor(
    @InjectModel(Review.name) private reviewModel: Model<ReviewDocument>,
  ) {}

  async create(createReviewDto: any): Promise<Review> {
    const createdReview = new this.reviewModel(createReviewDto);
    return createdReview.save();
  }

  async findAll(): Promise<Review[]> {
    return this.reviewModel.find().exec();
  }

  async findOne(id: string): Promise<Review | null> {
    return this.reviewModel.findById(id).exec();
  }

  async findByProject(projectId: string): Promise<Review[]> {
    return this.reviewModel
      .find({ projectId: new Types.ObjectId(projectId) })
      .populate('marks.reviewerId', 'name email')
      .populate('comments.reviewerId', 'name email')
      .exec();
  }

  async findByProjectAndReviewNumber(projectId: string, reviewNumber: number): Promise<Review | null> {
    return this.reviewModel
      .findOne({
        projectId: new Types.ObjectId(projectId),
        reviewNumber
      })
      .populate('marks.reviewerId', 'name email')
      .populate('comments.reviewerId', 'name email')
      .exec();
  }

  async addMarks(
    reviewId: string,
    marksData: {
      studentId: string;
      reviewerId: string;
      criteriaName: string;
      marksObtained: number;
    }
  ): Promise<Review | null> {
    return this.reviewModel.findByIdAndUpdate(
      reviewId,
      {
        $push: {
          marks: {
            studentId: new Types.ObjectId(marksData.studentId),
            reviewerId: new Types.ObjectId(marksData.reviewerId),
            criteriaName: marksData.criteriaName,
            marksObtained: marksData.marksObtained
          }
        }
      },
      { new: true }
    );
  }

  async addComment(
    reviewId: string,
    commentData: {
      reviewerId: string;
      comment: string;
    }
  ): Promise<Review | null> {
    return this.reviewModel.findByIdAndUpdate(
      reviewId,
      {
        $push: {
          comments: {
            reviewerId: new Types.ObjectId(commentData.reviewerId),
            comment: commentData.comment
          }
        }
      },
      { new: true }
    );
  }

  async calculateTotalScore(reviewId: string): Promise<number> {
    const review = await this.reviewModel.findById(reviewId).exec();
    if (!review) return 0;
    
    return review.marks.reduce((total, mark) => total + mark.marksObtained, 0);
  }

  async update(id: string, updateReviewDto: any): Promise<Review | null> {
    return this.reviewModel.findByIdAndUpdate(id, updateReviewDto, { new: true }).exec();
  }

  async remove(id: string): Promise<Review | null> {
    return this.reviewModel.findByIdAndDelete(id).exec();
  }
}