import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type EvaluationDocument = Evaluation & Document;

@Schema()
export class Evaluation {
  @Prop({ auto: true })
  _id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'ReviewPhase', required: true })
  reviewPhaseId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'Panel', required: true })
  panelId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  evaluatorId: Types.ObjectId; // Faculty member doing the evaluation

  @Prop({ type: Types.ObjectId, ref: 'Student', required: true })
  studentId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'EvaluationCriteria', required: true })
  criteriaId: Types.ObjectId;

  @Prop({ required: true, min: 0 })
  marksAwarded: number;

  @Prop()
  comments: string; // Optional comments per criterion

  @Prop({ default: false })
  isFinalized: boolean; // Once finalized, cannot be changed

  @Prop({ default: Date.now })
  evaluationDate: Date;

  @Prop({ default: Date.now })
  createdAt: Date;

  @Prop({ default: Date.now })
  updatedAt: Date;
}

export const EvaluationSchema = SchemaFactory.createForClass(Evaluation);

// Create compound index to ensure one evaluation per (evaluator + student + criteria + phase)
EvaluationSchema.index(
  { evaluatorId: 1, studentId: 1, criteriaId: 1, reviewPhaseId: 1 }, 
  { unique: true }
);