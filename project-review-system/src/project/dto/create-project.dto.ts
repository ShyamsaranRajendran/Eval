import { IsArray, IsNotEmpty, IsOptional, IsString, IsEnum, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

class ManualStudentDto {
  @IsNotEmpty()
  @IsString()
  studentName: string;

  @IsNotEmpty()
  @IsString()
  registerNo: string;

  @IsOptional()
  @IsString()
  email?: string;

  @IsOptional()
  @IsString()
  phone?: string;
}

export class CreateProjectDto {
  // Option 1: Use existing batch/team
  @IsOptional()
  @IsString()
  batchId?: string;

  @IsOptional()
  @IsString()
  teamId?: string;

  // Option 2: Use existing student users
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  teamMembers?: string[];

  // Option 3: Manual student entry
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ManualStudentDto)
  manualStudents?: ManualStudentDto[];

  @IsNotEmpty()
  @IsString()
  projectTitle: string;

  @IsOptional()
  @IsString()
  projectDescription?: string;

  @IsNotEmpty()
  @IsString()
  supervisorId: string;

  @IsOptional()
  @IsString()
  mentorId?: string;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  reviewers?: string[];

  @IsOptional()
  @IsEnum(['batch_team', 'existing_students', 'manual_entry'])
  studentSource?: string;
}