import { Controller, Get, Post, Put, Delete, Param, Body } from '@nestjs/common';
import { PanelService } from './panel.service';
import { Panel } from './schemas/panel.schema';

@Controller('panels')
export class PanelController {
  constructor(private readonly panelService: PanelService) {}

  @Post()
  async create(@Body() createPanelDto: any): Promise<Panel> {
    return this.panelService.create(createPanelDto);
  }

  @Get()
  async findAll(): Promise<Panel[]> {
    return this.panelService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<Panel | null> {
    return this.panelService.findWithDetails(id);
  }

  @Get('coordinator/:coordinatorId')
  async findByCoordinator(@Param('coordinatorId') coordinatorId: string): Promise<Panel[]> {
    return this.panelService.findByCoordinator(coordinatorId);
  }

  @Put(':id/projects')
  async assignProject(
    @Param('id') id: string,
    @Body() body: { projectId: string; reviewNumber: number }
  ): Promise<Panel | null> {
    return this.panelService.assignProject(id, body.projectId, body.reviewNumber);
  }

  @Delete(':id/projects/:projectId')
  async removeProject(
    @Param('id') id: string,
    @Param('projectId') projectId: string
  ): Promise<Panel | null> {
    return this.panelService.removeProject(id, projectId);
  }

  @Put(':id')
  async update(@Param('id') id: string, @Body() updatePanelDto: any): Promise<Panel | null> {
    return this.panelService.update(id, updatePanelDto);
  }

  @Delete(':id')
  async remove(@Param('id') id: string): Promise<Panel | null> {
    return this.panelService.remove(id);
  }
}