import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type PanelDocument = Panel & Document;

@Schema()
export class Panel {
  @Prop({ auto: true })
  _id: Types.ObjectId;

  @Prop({ required: true })
  name: string; // e.g., "Panel A", "Lab 101"

  @Prop()
  location: string; // e.g., "Block A-101"

  @Prop({ default: 25 })
  capacity: number; // Maximum students per panel

  @Prop({ default: 0 })
  currentCount: number; // Current number of assigned students

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  coordinatorId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'ReviewPhase', required: true })
  reviewPhaseId: Types.ObjectId;

  @Prop()
  scheduledDate: Date;

  @Prop()
  startTime: string; // e.g., "09:00"

  @Prop()
  endTime: string; // e.g., "17:00"

  @Prop({ default: true })
  isActive: boolean;

  @Prop({ default: Date.now })
  createdAt: Date;

  @Prop({ default: Date.now })
  updatedAt: Date;
}

export const PanelSchema = SchemaFactory.createForClass(Panel);