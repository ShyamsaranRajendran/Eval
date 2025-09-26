import { IsArray, IsNotEmpty, IsOptional, IsString, ArrayMinSize, ArrayMaxSize } from 'class-validator';

export class TeamDto {
  @IsNotEmpty()
  @IsString()
  teamName: string;

  @IsNotEmpty()
  @IsString()
  teamLeader: string; // User ID of the team leader (must be a Student)

  @IsArray()
  @ArrayMinSize(2) // Minimum 3 members including team leader
  @ArrayMaxSize(4) // Maximum 4 members
  @IsString({ each: true })
  members: string[]; // User IDs of team members (all must be Students)

  @IsOptional()
  @IsString()
  projectTitle?: string;

  @IsOptional()
  @IsString()
  projectDescription?: string;
}

export class CreateBatchDto {
  @IsNotEmpty()
  @IsString()
  batchName: string;

  @IsOptional()
  @IsString()
  department?: string;

  @IsOptional()
  year?: number;

  @IsNotEmpty()
  @IsString()
  mentorId: string; // User ID (must be Supervisor/Admin)

  @IsArray()
  teams: TeamDto[];
}