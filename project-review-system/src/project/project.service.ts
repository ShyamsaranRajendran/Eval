import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Project, ProjectDocument } from './schemas/project.schema';
import { CreateProjectDto } from './dto/create-project.dto';

@Injectable()
export class ProjectService {
  constructor(
    @InjectModel(Project.name) private projectModel: Model<ProjectDocument>,
  ) {}

  async createProject(createProjectDto: CreateProjectDto): Promise<Project> {
    // Validate the student source and data consistency
    this.validateStudentSource(createProjectDto);

    const projectData: any = {
      ...createProjectDto,
      supervisorId: new Types.ObjectId(createProjectDto.supervisorId),
    };

    // Set batchId if provided
    if (createProjectDto.batchId) {
      projectData.batchId = new Types.ObjectId(createProjectDto.batchId);
    }

    // Convert teamMembers to ObjectId array
    if (createProjectDto.teamMembers && createProjectDto.teamMembers.length > 0) {
      projectData.teamMembers = createProjectDto.teamMembers.map(id => new Types.ObjectId(id));
    }

    // Set mentorId if provided
    if (createProjectDto.mentorId) {
      projectData.mentorId = new Types.ObjectId(createProjectDto.mentorId);
    }

    // Convert reviewers to ObjectId array
    if (createProjectDto.reviewers && createProjectDto.reviewers.length > 0) {
      projectData.reviewers = createProjectDto.reviewers.map(id => new Types.ObjectId(id));
    }

    // Set studentSource based on provided data
    projectData.studentSource = this.determineStudentSource(createProjectDto);

    const createdProject = new this.projectModel(projectData);
    return createdProject.save();
  }

  private validateStudentSource(createProjectDto: CreateProjectDto): void {
    const { batchId, teamMembers, manualStudents } = createProjectDto;

    const hasBatchData = batchId;
    const hasExistingStudents = teamMembers && teamMembers.length > 0;
    const hasManualStudents = manualStudents && manualStudents.length > 0;

    // Count how many student sources are provided
    const sourceCount = [hasBatchData, hasExistingStudents, hasManualStudents].filter(Boolean).length;

    if (sourceCount > 1) {
      throw new BadRequestException('Please provide only one student source: batch/team, existing students, or manual students');
    }

    if (sourceCount === 0) {
      throw new BadRequestException('Please provide student information using one of: batch/team, existing students, or manual students');
    }
  }

  private determineStudentSource(createProjectDto: CreateProjectDto): string {
    const { batchId, teamMembers, manualStudents } = createProjectDto;

    if (batchId) return 'batch_team';
    if (teamMembers && teamMembers.length > 0) return 'existing_students';
    if (manualStudents && manualStudents.length > 0) return 'manual_entry';
    
    return 'manual_entry'; // default
  }

  async findAll(): Promise<Project[]> {
    return this.projectModel.find()
      .populate('batchId')
      .populate('supervisorId', 'name email role')
      .populate('mentorId', 'name email role')
      .populate('teamMembers', 'name email registerNo')
      .populate('reviewers', 'name email role')
      .exec();
  }

  async findProjectWithDetails(id: string): Promise<Project | null> {
    return this.projectModel.findById(id)
      .populate('batchId')
      .populate('supervisorId', 'name email role')
      .populate('mentorId', 'name email role')
      .populate('teamMembers', 'name email registerNo')
      .populate('reviewers', 'name email role')
      .exec();
  }

  async findByBatch(batchId: string): Promise<Project[]> {
    return this.projectModel.find({ batchId: new Types.ObjectId(batchId) })
      .populate('supervisorId', 'name email role')
      .populate('teamMembers', 'name email registerNo')
      .exec();
  }

  async findBySupervisor(supervisorId: string): Promise<Project[]> {
    return this.projectModel.find({ supervisorId: new Types.ObjectId(supervisorId) })
      .populate('batchId')
      .populate('teamMembers', 'name email registerNo')
      .exec();
  }

  async addStudentToProject(id: string, studentData: any): Promise<Project | null> {
    // For manual students addition
    return this.projectModel.findByIdAndUpdate(
      id,
      { 
        $push: { manualStudents: studentData },
        $set: { studentSource: 'manual_entry' }
      },
      { new: true }
    );
  }

  async assignReviewers(id: string, reviewerIds: string[]): Promise<Project | null> {
    const objectIds = reviewerIds.map(id => new Types.ObjectId(id));
    return this.projectModel.findByIdAndUpdate(
      id,
      { $set: { reviewers: objectIds } },
      { new: true }
    );
  }

  async update(id: string, updateProjectDto: any): Promise<Project | null> {
    // Handle ObjectId conversion for update
    const updateData: any = { ...updateProjectDto };

    if (updateProjectDto.supervisorId) {
      updateData.supervisorId = new Types.ObjectId(updateProjectDto.supervisorId);
    }
    if (updateProjectDto.batchId) {
      updateData.batchId = new Types.ObjectId(updateProjectDto.batchId);
    }
    if (updateProjectDto.teamMembers) {
      updateData.teamMembers = updateProjectDto.teamMembers.map((id: string) => new Types.ObjectId(id));
    }

    return this.projectModel.findByIdAndUpdate(id, updateData, { new: true });
  }

  async remove(id: string): Promise<Project | null> {
    return this.projectModel.findByIdAndDelete(id);
  }

}