import { Injectable, ConflictException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Student, StudentDocument } from './schemas/student.schema';

export interface CreateStudentDto {
  registerNo: string;
  name: string;
  projectTitle: string;
  supervisor: string;
  supervisorId?: string;
  email?: string;
  phone?: string;
  department?: string;
  batch?: string;
  semester?: number;
}

export interface UpdateStudentDto {
  registerNo?: string;
  name?: string;
  projectTitle?: string;
  supervisor?: string;
  supervisorId?: string;
  email?: string;
  phone?: string;
  department?: string;
  batch?: string;
  semester?: number;
  isActive?: boolean;
}

export interface BulkCreateStudentDto {
  students: CreateStudentDto[];
}

@Injectable()
export class StudentsService {
  constructor(
    @InjectModel(Student.name) private studentModel: Model<StudentDocument>,
  ) {}

  async create(createStudentDto: CreateStudentDto): Promise<Student> {
    // Check if registration number already exists
    const existingStudent = await this.studentModel.findOne({
      registerNo: createStudentDto.registerNo,
    });

    if (existingStudent) {
      throw new ConflictException(`Student with registration number ${createStudentDto.registerNo} already exists`);
    }

    const studentData = {
      ...createStudentDto,
      supervisorId: createStudentDto.supervisorId ? new Types.ObjectId(createStudentDto.supervisorId) : undefined,
    };

    const createdStudent = new this.studentModel(studentData);
    return createdStudent.save();
  }

  async bulkCreate(bulkDto: BulkCreateStudentDto): Promise<{
    created: Student[];
    errors: Array<{ registerNo: string; error: string }>;
  }> {
    const created: Student[] = [];
    const errors: Array<{ registerNo: string; error: string }> = [];

    for (const studentDto of bulkDto.students) {
      try {
        const student = await this.create(studentDto);
        created.push(student);
      } catch (error) {
        errors.push({
          registerNo: studentDto.registerNo,
          error: error.message,
        });
      }
    }

    return { created, errors };
  }

  async findAll(filters?: {
    batch?: string;
    department?: string;
    isActive?: boolean;
  }): Promise<Student[]> {
    const query: any = {};
    
    if (filters?.batch) query.batch = filters.batch;
    if (filters?.department) query.department = filters.department;
    if (filters?.isActive !== undefined) query.isActive = filters.isActive;

    return this.studentModel
      .find(query)
      .populate('supervisorId', 'name email')
      .sort({ registerNo: 1 })
      .exec();
  }

  async findOne(id: string): Promise<Student | null> {
    return this.studentModel
      .findById(id)
      .populate('supervisorId', 'name email department')
      .exec();
  }

  async findByRegisterNo(registerNo: string): Promise<Student | null> {
    return this.studentModel
      .findOne({ registerNo })
      .populate('supervisorId', 'name email department')
      .exec();
  }

  async findBySupervisor(supervisorId: string): Promise<Student[]> {
    return this.studentModel
      .find({ supervisorId: new Types.ObjectId(supervisorId) })
      .sort({ registerNo: 1 })
      .exec();
  }

  async findByBatch(batch: string): Promise<Student[]> {
    return this.studentModel
      .find({ batch, isActive: true })
      .populate('supervisorId', 'name email')
      .sort({ registerNo: 1 })
      .exec();
  }

  async search(query: string): Promise<Student[]> {
    const searchRegex = new RegExp(query, 'i');
    return this.studentModel
      .find({
        $or: [
          { name: searchRegex },
          { registerNo: searchRegex },
          { projectTitle: searchRegex },
          { supervisor: searchRegex },
        ],
        isActive: true,
      })
      .populate('supervisorId', 'name email')
      .sort({ registerNo: 1 })
      .limit(50)
      .exec();
  }

  async update(id: string, updateStudentDto: UpdateStudentDto): Promise<Student | null> {
    // If updating registerNo, check for duplicates
    if (updateStudentDto.registerNo) {
      const existingStudent = await this.studentModel.findOne({
        registerNo: updateStudentDto.registerNo,
        _id: { $ne: id },
      });

      if (existingStudent) {
        throw new ConflictException(`Student with registration number ${updateStudentDto.registerNo} already exists`);
      }
    }

    const updateData = {
      ...updateStudentDto,
      supervisorId: updateStudentDto.supervisorId ? new Types.ObjectId(updateStudentDto.supervisorId) : undefined,
      updatedAt: new Date(),
    };

    return this.studentModel
      .findByIdAndUpdate(id, updateData, { new: true })
      .populate('supervisorId', 'name email')
      .exec();
  }

  async remove(id: string): Promise<Student | null> {
    // Soft delete by setting isActive to false
    return this.studentModel
      .findByIdAndUpdate(
        id,
        { isActive: false, updatedAt: new Date() },
        { new: true },
      )
      .exec();
  }

  async getStats(): Promise<{
    totalStudents: number;
    activeStudents: number;
    studentsByBatch: Array<{ batch: string; count: number }>;
    studentsByDepartment: Array<{ department: string; count: number }>;
  }> {
    const [totalStudents, activeStudents, batchStats, deptStats] = await Promise.all([
      this.studentModel.countDocuments({}),
      this.studentModel.countDocuments({ isActive: true }),
      this.studentModel.aggregate([
        { $match: { isActive: true } },
        { $group: { _id: '$batch', count: { $sum: 1 } } },
        { $project: { batch: '$_id', count: 1, _id: 0 } },
        { $sort: { batch: -1 } },
      ]),
      this.studentModel.aggregate([
        { $match: { isActive: true } },
        { $group: { _id: '$department', count: { $sum: 1 } } },
        { $project: { department: '$_id', count: 1, _id: 0 } },
        { $sort: { department: 1 } },
      ]),
    ]);

    return {
      totalStudents,
      activeStudents,
      studentsByBatch: batchStats,
      studentsByDepartment: deptStats,
    };
  }
}