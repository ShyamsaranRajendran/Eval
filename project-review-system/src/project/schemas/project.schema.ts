import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type ProjectDocument = Project & Document;

@Schema({ timestamps: true })
export class Project {
  _id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'Batch' })
  batchId: Types.ObjectId; // Optional: if using existing batch

  @Prop({ required: true })
  projectTitle: string;

  @Prop()
  projectDescription: string;

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  supervisorId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'User' })
  mentorId: Types.ObjectId;

  // OPTION 1: Reference existing students from Users
  @Prop([{ 
    type: Types.ObjectId, 
    ref: 'User'
  }])
  teamMembers: Types.ObjectId[];

  // OPTION 2: Manually enter student details (when not using batch/team)
  @Prop([{
    studentName: { type: String },
    registerNo: { type: String },
    email: { type: String },
    phone: { type: String }
  }])
  manualStudents: Array<{
    studentName: string;
    registerNo: string;
    email?: string;
    phone?: string;
  }>;

  @Prop([{ type: Types.ObjectId, ref: 'User' }])
  reviewers: Types.ObjectId[];

  @Prop({ 
    type: String, 
    enum: ['Planning', 'In Progress', 'Under Review', 'Completed', 'Presented'],
    default: 'Planning'
  })
  status: string;

  // Track which method was used to add students
  @Prop({
    type: String,
    enum: ['batch_team', 'existing_students', 'manual_entry'],
    default: 'manual_entry'
  })
  studentSource: string;

  @Prop({ default: Date.now })
  createdAt: Date;

  @Prop({ default: Date.now })
  updatedAt: Date;
}

export const ProjectSchema = SchemaFactory.createForClass(Project);