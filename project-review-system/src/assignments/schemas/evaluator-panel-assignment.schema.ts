import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type EvaluatorPanelAssignmentDocument = EvaluatorPanelAssignment & Document;

export enum EvaluatorRole {
  REVIEWER_1 = 'reviewer1',
  REVIEWER_2 = 'reviewer2',
  SUPERVISOR = 'supervisor',
  EXTERNAL = 'external'
}

@Schema()
export class EvaluatorPanelAssignment {
  @Prop({ auto: true })
  _id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  evaluatorId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'Panel', required: true })
  panelId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'ReviewPhase', required: true })
  reviewPhaseId: Types.ObjectId;

  @Prop({ required: true, enum: Object.values(EvaluatorRole) })
  roleInPanel: EvaluatorRole;

  @Prop({ default: true })
  isActive: boolean;

  @Prop({ default: Date.now })
  assignedAt: Date;

  @Prop({ default: Date.now })
  updatedAt: Date;
}

export const EvaluatorPanelAssignmentSchema = SchemaFactory.createForClass(EvaluatorPanelAssignment);

// Ensure one evaluator can't have multiple roles in same panel
EvaluatorPanelAssignmentSchema.index(
  { evaluatorId: 1, panelId: 1 }, 
  { unique: true }
);