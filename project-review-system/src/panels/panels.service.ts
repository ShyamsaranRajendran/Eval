import { Injectable, ConflictException, BadRequestException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Panel, PanelDocument } from './schemas/panel.schema';

export interface CreatePanelDto {
  name: string;
  location?: string;
  capacity?: number;
  coordinatorId: string;
  reviewPhaseId: string;
  scheduledDate?: Date;
  startTime?: string;
  endTime?: string;
}

export interface UpdatePanelDto {
  name?: string;
  location?: string;
  capacity?: number;
  coordinatorId?: string;
  scheduledDate?: Date;
  startTime?: string;
  endTime?: string;
  isActive?: boolean;
}

@Injectable()
export class PanelsService {
  constructor(
    @InjectModel(Panel.name) private panelModel: Model<PanelDocument>,
  ) {}

  async create(createPanelDto: CreatePanelDto): Promise<Panel> {
    // Check if panel name already exists for this review phase
    const existingPanel = await this.panelModel.findOne({
      name: createPanelDto.name,
      reviewPhaseId: new Types.ObjectId(createPanelDto.reviewPhaseId),
    });

    if (existingPanel) {
      throw new ConflictException(
        `Panel with name ${createPanelDto.name} already exists for this review phase`,
      );
    }

    const panelData = {
      ...createPanelDto,
      coordinatorId: new Types.ObjectId(createPanelDto.coordinatorId),
      reviewPhaseId: new Types.ObjectId(createPanelDto.reviewPhaseId),
    };

    const createdPanel = new this.panelModel(panelData);
    return createdPanel.save();
  }

  async findAll(): Promise<Panel[]> {
    return this.panelModel
      .find({ isActive: true })
      .populate('coordinatorId', 'name email department')
      .populate('reviewPhaseId', 'name order academicYear')
      .sort({ name: 1 })
      .exec();
  }

  async findByReviewPhase(reviewPhaseId: string): Promise<Panel[]> {
    return this.panelModel
      .find({
        reviewPhaseId: new Types.ObjectId(reviewPhaseId),
        isActive: true,
      })
      .populate('coordinatorId', 'name email department')
      .sort({ name: 1 })
      .exec();
  }

  async findByCoordinator(coordinatorId: string): Promise<Panel[]> {
    return this.panelModel
      .find({
        coordinatorId: new Types.ObjectId(coordinatorId),
        isActive: true,
      })
      .populate('reviewPhaseId', 'name order academicYear')
      .sort({ name: 1 })
      .exec();
  }

  async findOne(id: string): Promise<Panel | null> {
    return this.panelModel
      .findById(id)
      .populate('coordinatorId', 'name email department')
      .populate('reviewPhaseId', 'name order academicYear')
      .exec();
  }

  async update(id: string, updatePanelDto: UpdatePanelDto): Promise<Panel | null> {
    // If updating name, check for conflicts
    if (updatePanelDto.name) {
      const panel = await this.panelModel.findById(id);
      if (panel) {
        const existingPanel = await this.panelModel.findOne({
          name: updatePanelDto.name,
          reviewPhaseId: panel.reviewPhaseId,
          _id: { $ne: id },
        });

        if (existingPanel) {
          throw new ConflictException(
            `Panel with name ${updatePanelDto.name} already exists for this review phase`,
          );
        }
      }
    }

    const updateData = {
      ...updatePanelDto,
      coordinatorId: updatePanelDto.coordinatorId 
        ? new Types.ObjectId(updatePanelDto.coordinatorId) 
        : undefined,
      updatedAt: new Date(),
    };

    return this.panelModel
      .findByIdAndUpdate(id, updateData, { new: true })
      .populate('coordinatorId', 'name email department')
      .populate('reviewPhaseId', 'name order academicYear')
      .exec();
  }

  async remove(id: string): Promise<Panel | null> {
    // Check if panel has assigned students/evaluators before deletion
    const panel = await this.panelModel.findById(id);
    if (panel && panel.currentCount > 0) {
      throw new BadRequestException('Cannot delete panel with assigned students');
    }

    // Soft delete
    return this.panelModel
      .findByIdAndUpdate(
        id,
        { isActive: false, updatedAt: new Date() },
        { new: true },
      )
      .exec();
  }

  async incrementStudentCount(id: string): Promise<Panel | null> {
    return this.panelModel
      .findByIdAndUpdate(
        id,
        { $inc: { currentCount: 1 }, updatedAt: new Date() },
        { new: true },
      )
      .exec();
  }

  async decrementStudentCount(id: string): Promise<Panel | null> {
    return this.panelModel
      .findByIdAndUpdate(
        id,
        { $inc: { currentCount: -1 }, updatedAt: new Date() },
        { new: true },
      )
      .exec();
  }

  async getAvailablePanels(reviewPhaseId: string): Promise<Panel[]> {
    return this.panelModel
      .find({
        reviewPhaseId: new Types.ObjectId(reviewPhaseId),
        isActive: true,
        $expr: { $lt: ['$currentCount', '$capacity'] },
      })
      .populate('coordinatorId', 'name email')
      .sort({ currentCount: 1, name: 1 })
      .exec();
  }

  async getPanelStats(reviewPhaseId?: string): Promise<{
    totalPanels: number;
    activePanels: number;
    totalCapacity: number;
    totalAssigned: number;
    utilizationRate: number;
    panelDetails: Array<{
      panelId: string;
      name: string;
      capacity: number;
      assigned: number;
      utilizationRate: number;
    }>;
  }> {
    const query: any = { isActive: true };
    if (reviewPhaseId) {
      query.reviewPhaseId = new Types.ObjectId(reviewPhaseId);
    }

    const panels = await this.panelModel.find(query).exec();
    
    const totalPanels = panels.length;
    const activePanels = panels.filter(p => p.isActive).length;
    const totalCapacity = panels.reduce((sum, p) => sum + p.capacity, 0);
    const totalAssigned = panels.reduce((sum, p) => sum + p.currentCount, 0);
    const utilizationRate = totalCapacity > 0 ? (totalAssigned / totalCapacity) * 100 : 0;

    const panelDetails = panels.map(panel => ({
      panelId: panel._id.toString(),
      name: panel.name,
      capacity: panel.capacity,
      assigned: panel.currentCount,
      utilizationRate: panel.capacity > 0 ? (panel.currentCount / panel.capacity) * 100 : 0,
    }));

    return {
      totalPanels,
      activePanels,
      totalCapacity,
      totalAssigned,
      utilizationRate: Math.round(utilizationRate * 100) / 100,
      panelDetails,
    };
  }
}