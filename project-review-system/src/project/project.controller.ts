import { Controller, Get, Post, Put, Delete, Param, Body } from '@nestjs/common';
import { ProjectService } from './project.service';
import { Project } from './schemas/project.schema';
import { CreateProjectDto } from './dto/create-project.dto';

@Controller('projects')
export class ProjectController {
  constructor(private readonly projectService: ProjectService) {}

  @Post()
  async create(@Body() createProjectDto: CreateProjectDto): Promise<Project> {
    return this.projectService.createProject(createProjectDto);
  }

  @Get()
  async findAll(): Promise<Project[]> {
    return this.projectService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<Project | null> {
    return this.projectService.findProjectWithDetails(id);
  }

  @Get('batch/:batchId')
  async findByBatch(@Param('batchId') batchId: string): Promise<Project[]> {
    return this.projectService.findByBatch(batchId);
  }

  @Get('supervisor/:supervisorId')
  async findBySupervisor(@Param('supervisorId') supervisorId: string): Promise<Project[]> {
    return this.projectService.findBySupervisor(supervisorId);
  }

  @Put(':id/students')
  async addStudent(@Param('id') id: string, @Body() studentData: any): Promise<Project | null> {
    return this.projectService.addStudentToProject(id, studentData);
  }

  @Put(':id/reviewers')
  async assignReviewers(@Param('id') id: string, @Body() body: { reviewerIds: string[] }): Promise<Project | null> {
    return this.projectService.assignReviewers(id, body.reviewerIds);
  }

  @Put(':id')
  async update(@Param('id') id: string, @Body() updateProjectDto: any): Promise<Project | null> {
    return this.projectService.update(id, updateProjectDto);
  }

  @Delete(':id')
  async remove(@Param('id') id: string): Promise<Project | null> {
    return this.projectService.remove(id);
  }
}