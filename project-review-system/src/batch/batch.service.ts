import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Batch, BatchDocument } from './schemas/batch.schema';
import { CreateBatchDto } from './dto/create-batch.dto';
import { UserService } from '../user/user.service';

@Injectable()
export class BatchService {
  findAll(): Batch[] | PromiseLike<Batch[]> {
      throw new Error('Method not implemented.');
  }
  findOne(id: string): Batch | PromiseLike<Batch | null> | null {
      throw new Error('Method not implemented.');
  }
  findByDepartment(department: string): Batch[] | PromiseLike<Batch[]> {
      throw new Error('Method not implemented.');
  }
  findByYear(arg0: number): Batch[] | PromiseLike<Batch[]> {
      throw new Error('Method not implemented.');
  }
  update(id: string, updateBatchDto: any): Batch | PromiseLike<Batch | null> | null {
      throw new Error('Method not implemented.');
  }
  remove(id: string): Batch | PromiseLike<Batch | null> | null {
      throw new Error('Method not implemented.');
  }
  constructor(
    @InjectModel(Batch.name) private batchModel: Model<BatchDocument>,
    private userService: UserService,
  ) {}

  async create(createBatchDto: CreateBatchDto): Promise<Batch> {
    // Validate mentor exists and has correct role
    const mentor = await this.userService.findOne(createBatchDto.mentorId);
    if (!mentor || !['Admin', 'Supervisor'].includes(mentor.role)) {
      throw new BadRequestException('Mentor must be an Admin or Supervisor');
    }

    // Validate team members are students
    for (const team of createBatchDto.teams) {
      const teamLeader = await this.userService.findOne(team.teamLeader);
      if (!teamLeader || teamLeader.role !== 'Student') {
        throw new BadRequestException('Team leader must be a Student');
      }

      for (const memberId of team.members) {
        const member = await this.userService.findOne(memberId);
        if (!member || member.role !== 'Student') {
          throw new BadRequestException('All team members must be Students');
        }
      }
    }

    const batchData = {
      ...createBatchDto,
      mentorId: new Types.ObjectId(createBatchDto.mentorId),
      teams: createBatchDto.teams.map(team => ({
        ...team,
        teamLeader: new Types.ObjectId(team.teamLeader),
        members: team.members.map(memberId => new Types.ObjectId(memberId)),
      })),
    };

    const createdBatch = new this.batchModel(batchData);
    return createdBatch.save();
  }

  async findBatchWithTeamDetails(batchId: string): Promise<Batch> {
    const batch = await this.batchModel.findById(batchId)
      .populate('mentorId', 'name email role')
      .populate('teams.teamLeader', 'name email')
      .populate('teams.members', 'name email registerNo')
      .exec();
    if (!batch) {
      throw new BadRequestException('Batch not found');
    }
    return batch as unknown as Batch;
  }
}