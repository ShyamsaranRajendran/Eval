import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type PanelDocument = Panel & Document;

@Schema({ timestamps: true })
export class Panel {
  _id: Types.ObjectId;

  @Prop({ required: true })
  panelName: string;

  @Prop({ type: Types.ObjectId, ref: 'User' })
  facultyCoordinatorId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'User' })
  studentCoordinatorId: Types.ObjectId;

  @Prop()
  studentCoordinatorPhone: string;

  @Prop()
  venue: string;

  // Projects assigned to this panel with review numbers
  @Prop([{
    projectId: { type: Types.ObjectId, ref: 'Project' },
    reviewNumber: { type: Number } // 1 = Review I, 2 = Review II, etc.
  }])
  projects: {
    projectId: Types.ObjectId;
    reviewNumber: number;
  }[];

  @Prop({ default: Date.now })
  createdAt: Date;
}

export const PanelSchema = SchemaFactory.createForClass(Panel);