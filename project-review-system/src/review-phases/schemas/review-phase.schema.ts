import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type ReviewPhaseDocument = ReviewPhase & Document;

@Schema()
export class ReviewPhase {
  @Prop({ auto: true })
  _id: Types.ObjectId;

  @Prop({ required: true })
  name: string; // e.g., "Review I", "Review II"

  @Prop({ required: true })
  order: number; // 1, 2, 3, etc.

  @Prop({ required: true })
  academicYear: string; // e.g., "2023-2024"

  @Prop({ default: false })
  isActive: boolean; // Only one active phase at a time

  @Prop()
  startDate: Date;

  @Prop()
  endDate: Date;

  @Prop()
  description: string;

  @Prop({ default: Date.now })
  createdAt: Date;

  @Prop({ default: Date.now })
  updatedAt: Date;
}

export const ReviewPhaseSchema = SchemaFactory.createForClass(ReviewPhase);