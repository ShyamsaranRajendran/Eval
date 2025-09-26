import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type BatchDocument = Batch & Document;

@Schema({ timestamps: true })
export class Batch {
  _id: Types.ObjectId;

  @Prop({ required: true })
  batchName: string;

  @Prop()
  department: string;

  @Prop()
  year: number;

  // Mentor/Guide for the batch (must be a Supervisor/Admin from Users)
  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  mentorId: Types.ObjectId;

  // Teams in this batch (each team has 3-4 student members from Users)
  @Prop([{
    teamName: { type: String, required: true },
    teamLeader: { 
      type: Types.ObjectId, 
      ref: 'User', 
      required: true 
    },
    members: [{
      type: Types.ObjectId, 
      ref: 'User',
      required: true
    }],
    projectTitle: { type: String },
    projectDescription: { type: String },
    status: { 
      type: String, 
      enum: ['Active', 'Completed', 'Inactive'], 
      default: 'Active' 
    }
  }])
  teams: Array<{
    teamName: string;
    teamLeader: Types.ObjectId;
    members: Types.ObjectId[];
    projectTitle?: string;
    projectDescription?: string;
    status: string;
    _id?: Types.ObjectId;
  }>;

  @Prop({ default: Date.now })
  createdAt: Date;

  @Prop({ default: Date.now })
  updatedAt: Date;
}

export const BatchSchema = SchemaFactory.createForClass(Batch);