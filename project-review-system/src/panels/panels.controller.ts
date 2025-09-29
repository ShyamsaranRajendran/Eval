import { Controller, Get, Post, Put, Delete, Param, Body, Query, UseGuards } from '@nestjs/common';
import { PanelsService } from './panels.service';
import type { CreatePanelDto, UpdatePanelDto } from './panels.service';
import { Panel } from './schemas/panel.schema';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';
import { UserRole } from '../users/schemas/user.schema';

@Controller('panels')
@UseGuards(JwtAuthGuard, RolesGuard)
export class PanelsController {
  constructor(private readonly panelsService: PanelsService) {}

  @Post()
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async create(@Body() createPanelDto: CreatePanelDto): Promise<Panel> {
    return this.panelsService.create(createPanelDto);
  }

  @Get()
  async findAll(): Promise<Panel[]> {
    return this.panelsService.findAll();
  }

  @Get('stats')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async getPanelStats(@Query('reviewPhaseId') reviewPhaseId?: string): Promise<{
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
    return this.panelsService.getPanelStats(reviewPhaseId);
  }

  @Get('review-phase/:phaseId')
  async findByReviewPhase(@Param('phaseId') phaseId: string): Promise<Panel[]> {
    return this.panelsService.findByReviewPhase(phaseId);
  }

  @Get('review-phase/:phaseId/available')
  async getAvailablePanels(@Param('phaseId') phaseId: string): Promise<Panel[]> {
    return this.panelsService.getAvailablePanels(phaseId);
  }

  @Get('coordinator/:coordinatorId')
  async findByCoordinator(@Param('coordinatorId') coordinatorId: string): Promise<Panel[]> {
    return this.panelsService.findByCoordinator(coordinatorId);
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<Panel | null> {
    return this.panelsService.findOne(id);
  }

  @Put(':id')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async update(
    @Param('id') id: string,
    @Body() updatePanelDto: UpdatePanelDto,
  ): Promise<Panel | null> {
    return this.panelsService.update(id, updatePanelDto);
  }

  @Delete(':id')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async remove(@Param('id') id: string): Promise<Panel | null> {
    return this.panelsService.remove(id);
  }
}