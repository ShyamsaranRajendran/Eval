import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type EvaluationCriteriaDocument = EvaluationCriteria & Document;

@Schema()
export class EvaluationCriteria {
  @Prop({ auto: true })
  _id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'ReviewPhase', required: true })
  reviewPhaseId: Types.ObjectId;

  @Prop({ required: true })
  name: string; // e.g., "System Study", "Implementation"

  @Prop()
  description: string;

  @Prop({ required: true, min: 1 })
  maxMarks: number;

  @Prop({ default: 1, min: 0.1, max: 2 })
  weightage: number; // For weighted calculations

  @Prop({ required: true, min: 1 })
  order: number; // For display order

  @Prop({ default: true })
  isActive: boolean;

  @Prop({ default: Date.now })
  createdAt: Date;

  @Prop({ default: Date.now })
  updatedAt: Date;
}

export const EvaluationCriteriaSchema = SchemaFactory.createForClass(EvaluationCriteria);