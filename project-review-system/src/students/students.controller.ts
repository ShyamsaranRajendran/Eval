import { Controller, Get, Post, Put, Delete, Param, Body, Query, UseGuards } from '@nestjs/common';
import { StudentsService } from './students.service';
import type { CreateStudentDto, UpdateStudentDto, BulkCreateStudentDto } from './students.service';
import { Student } from './schemas/student.schema';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';
import { UserRole } from '../users/schemas/user.schema';

@Controller('students')
@UseGuards(JwtAuthGuard, RolesGuard)
export class StudentsController {
  constructor(private readonly studentsService: StudentsService) {}

  @Post()
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async create(@Body() createStudentDto: CreateStudentDto): Promise<Student> {
    return this.studentsService.create(createStudentDto);
  }

  @Post('bulk-upload')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async bulkCreate(@Body() bulkDto: BulkCreateStudentDto): Promise<{
    created: Student[];
    errors: Array<{ registerNo: string; error: string }>;
  }> {
    return this.studentsService.bulkCreate(bulkDto);
  }

  @Get()
  async findAll(
    @Query('batch') batch?: string,
    @Query('department') department?: string,
    @Query('isActive') isActive?: string,
  ): Promise<Student[]> {
    const filters: any = {};
    if (batch) filters.batch = batch;
    if (department) filters.department = department;
    if (isActive !== undefined) filters.isActive = isActive === 'true';

    return this.studentsService.findAll(filters);
  }

  @Get('stats')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async getStats(): Promise<{
    totalStudents: number;
    activeStudents: number;
    studentsByBatch: Array<{ batch: string; count: number }>;
    studentsByDepartment: Array<{ department: string; count: number }>;
  }> {
    return this.studentsService.getStats();
  }

  @Get('search')
  async search(@Query('q') query: string): Promise<Student[]> {
    if (!query) return [];
    return this.studentsService.search(query);
  }

  @Get('batch/:batch')
  async findByBatch(@Param('batch') batch: string): Promise<Student[]> {
    return this.studentsService.findByBatch(batch);
  }

  @Get('supervisor/:supervisorId')
  async findBySupervisor(@Param('supervisorId') supervisorId: string): Promise<Student[]> {
    return this.studentsService.findBySupervisor(supervisorId);
  }

  @Get('register/:registerNo')
  async findByRegisterNo(@Param('registerNo') registerNo: string): Promise<Student | null> {
    return this.studentsService.findByRegisterNo(registerNo);
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<Student | null> {
    return this.studentsService.findOne(id);
  }

  @Put(':id')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async update(
    @Param('id') id: string,
    @Body() updateStudentDto: UpdateStudentDto,
  ): Promise<Student | null> {
    return this.studentsService.update(id, updateStudentDto);
  }

  @Delete(':id')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async remove(@Param('id') id: string): Promise<Student | null> {
    return this.studentsService.remove(id);
  }
}