import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type StudentDocument = Student & Document;

@Schema()
export class Student {
  @Prop({ auto: true })
  _id: Types.ObjectId;

  @Prop({ required: true, unique: true })
  registerNo: string; // Student registration number

  @Prop({ required: true })
  name: string;

  @Prop({ required: true })
  projectTitle: string;

  @Prop({ required: true })
  supervisor: string; // Supervisor name or could be ObjectId ref to User

  @Prop({ type: Types.ObjectId, ref: 'User' })
  supervisorId: Types.ObjectId; // Reference to supervisor user

  @Prop()
  email: string;

  @Prop()
  phone: string;

  @Prop()
  department: string;

  @Prop()
  batch: string; // e.g., "2024", "2023-2024"

  @Prop()
  semester: number;

  @Prop({ default: true })
  isActive: boolean;

  @Prop({ default: Date.now })
  createdAt: Date;

  @Prop({ default: Date.now })
  updatedAt: Date;
}

export const StudentSchema = SchemaFactory.createForClass(Student);