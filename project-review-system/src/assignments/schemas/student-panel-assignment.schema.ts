import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type StudentPanelAssignmentDocument = StudentPanelAssignment & Document;

@Schema()
export class StudentPanelAssignment {
  @Prop({ auto: true })
  _id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'Student', required: true })
  studentId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'Panel', required: true })
  panelId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'ReviewPhase', required: true })
  reviewPhaseId: Types.ObjectId;

  @Prop()
  scheduledDateTime: Date;

  @Prop({ default: true })
  isActive: boolean;

  @Prop({ default: Date.now })
  assignedAt: Date;

  @Prop({ default: Date.now })
  updatedAt: Date;
}

export const StudentPanelAssignmentSchema = SchemaFactory.createForClass(StudentPanelAssignment);

// Ensure one student can only be assigned to one panel per review phase
StudentPanelAssignmentSchema.index(
  { studentId: 1, reviewPhaseId: 1 }, 
  { unique: true }
);