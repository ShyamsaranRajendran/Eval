import { Controller, Get, Post, Put, Delete, Param, Body, UseGuards } from '@nestjs/common';
import { UsersService } from './users.service';
import type { CreateUserDto, UpdateUserDto } from './users.service';
import { User, UserRole } from './schemas/user.schema';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('users')
// @UseGuards(JwtAuthGuard, RolesGuard)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  @Roles(UserRole.ADMIN)
  async create(@Body() createUserDto: CreateUserDto): Promise<User> {
    return this.usersService.create(createUserDto);
  }

  @Get()
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async findAll(): Promise<User[]> {
    return this.usersService.findAll();
  }

   @Post('create-admin')
  async createAdmin(@Body() body: { name: string; email: string; password: string }): Promise<User> {
    return this.usersService.createAdmin(body.email, body.password, body.name);
  }

  @Get('faculty')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async getFaculty(): Promise<User[]> {
    return this.usersService.getFaculty();
  }

  @Get('coordinators')
  @Roles(UserRole.ADMIN)
  async getCoordinators(): Promise<User[]> {
    return this.usersService.getCoordinators();
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<User | null> {
    return this.usersService.findOne(id);
  }

  @Put(':id')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto): Promise<User | null> {
    return this.usersService.update(id, updateUserDto);
  }

  @Delete(':id')
  @Roles(UserRole.ADMIN)
  async deactivate(@Param('id') id: string): Promise<User | null> {
    return this.usersService.deactivate(id);
  }

  @Put(':id/change-password')
  async changePassword(
    @Param('id') id: string,
    @Body() body: { newPassword: string }
  ): Promise<User | null> {
    return this.usersService.changePassword(id, body.newPassword);
  }
}