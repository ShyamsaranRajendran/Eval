import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Panel, PanelDocument } from './schemas/panel.schema';

@Injectable()
export class PanelService {
  constructor(
    @InjectModel(Panel.name) private panelModel: Model<PanelDocument>,
  ) {}

  async create(createPanelDto: any): Promise<Panel> {
    const createdPanel = new this.panelModel(createPanelDto);
    return createdPanel.save();
  }

  async findAll(): Promise<Panel[]> {
    return this.panelModel.find().exec();
  }

  async findOne(id: string): Promise<Panel | null> {
    return this.panelModel.findById(id).exec();
  }

  async findWithDetails(id: string): Promise<Panel | null> {
    return this.panelModel
      .findById(id)
      .populate('facultyCoordinatorId', 'name email')
      .populate('studentCoordinatorId', 'name email')
      .populate('projects.projectId', 'projectTitle students')
      .exec();
  }

  async findByCoordinator(coordinatorId: string): Promise<Panel[]> {
    return this.panelModel
      .find({
        $or: [
          { facultyCoordinatorId: new Types.ObjectId(coordinatorId) },
          { studentCoordinatorId: new Types.ObjectId(coordinatorId) }
        ]
      })
      .populate('facultyCoordinatorId', 'name email')
      .populate('studentCoordinatorId', 'name email')
      .exec();
  }

  async assignProject(panelId: string, projectId: string, reviewNumber: number): Promise<Panel | null> {
    return this.panelModel.findByIdAndUpdate(
      panelId,
      {
        $push: {
          projects: {
            projectId: new Types.ObjectId(projectId),
            reviewNumber
          }
        }
      },
      { new: true }
    );
  }

  async removeProject(panelId: string, projectId: string): Promise<Panel | null> {
    return this.panelModel.findByIdAndUpdate(
      panelId,
      {
        $pull: {
          projects: { projectId: new Types.ObjectId(projectId) }
        }
      },
      { new: true }
    );
  }

  async update(id: string, updatePanelDto: any): Promise<Panel | null> {
    return this.panelModel.findByIdAndUpdate(id, updatePanelDto, { new: true }).exec();
  }

  async remove(id: string): Promise<Panel | null> {
    return this.panelModel.findByIdAndDelete(id).exec();
  }
}