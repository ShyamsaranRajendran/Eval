import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type ReviewDocument = Review & Document;

@Schema()
export class ReviewCriteria {
  @Prop({ required: true })
  criteriaName: string;

  @Prop({ required: true })
  maxMarks: number;
}

@Schema({ timestamps: true })
export class Review {
  _id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'Project', required: true })
  projectId: Types.ObjectId;

  @Prop({ required: true })
  reviewNumber: number; // 1 = Review I, 2 = Review II, etc.

  @Prop({ default: 100 })
  maxTotal: number;

  @Prop({ type: Number, min: 0, max: 1 })
  weight: number; // e.g., 0.3, 0.4

  @Prop({ type: Date, default: Date.now })
  reviewDate: Date;

  // Embedded criteria
  @Prop([ReviewCriteria])
  criteria: ReviewCriteria[];

  // Marks per student per criteria
  @Prop([{
    studentId: { type: Types.ObjectId, ref: 'Project.students' },
    reviewerId: { type: Types.ObjectId, ref: 'User' },
    criteriaName: String,
    marksObtained: Number
  }])
  marks: {
    studentId: Types.ObjectId;
    reviewerId: Types.ObjectId;
    criteriaName: string;
    marksObtained: number;
  }[];

  // Comments
  @Prop([{
    reviewerId: { type: Types.ObjectId, ref: 'User' },
    comment: String
  }])
  comments: {
    reviewerId: Types.ObjectId;
    comment: string;
  }[];

  @Prop({ default: Date.now })
  createdAt: Date;
}

export const ReviewSchema = SchemaFactory.createForClass(Review);