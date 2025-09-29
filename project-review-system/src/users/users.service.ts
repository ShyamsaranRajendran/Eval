import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User, UserDocument, UserRole } from './schemas/user.schema';
import * as bcrypt from 'bcrypt';

export interface CreateUserDto {
  email: string;
  password: string;
  name: string;
  role: UserRole;
  department?: string;
}

export interface UpdateUserDto {
  name?: string;
  department?: string;
  isActive?: boolean;
}

@Injectable()
export class UsersService {
  constructor(
    @InjectModel(User.name) private userModel: Model<UserDocument>,
  ) {}

  async createAdmin(email: string, password: string, name: string): Promise<User> {
  const bcrypt = await import('bcrypt');
  const hashedPassword = await bcrypt.hash(password, 10);

  // Check if admin already exists
  const existing = await this.userModel.findOne({ email });
  if (existing) {
    throw new Error('Admin with this email already exists');
  }

  return this.userModel.create({
    name,
    email,
    password: hashedPassword,
    role: UserRole.ADMIN,
    isActive: true
  });
}



  async create(createUserDto: CreateUserDto): Promise<User> {
    const hashedPassword = await bcrypt.hash(createUserDto.password, 10);
    const createdUser = new this.userModel({
      ...createUserDto,
      password: hashedPassword,
    });
    return createdUser.save();
  }

  async findAll(): Promise<User[]> {
    return this.userModel.find().select('-password').exec();
  }

  async findOne(id: string): Promise<User | null> {
    return this.userModel.findById(id).select('-password').exec();
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.userModel.findOne({ email }).exec();
  }

  async findByRole(role: UserRole): Promise<User[]> {
    return this.userModel.find({ role, isActive: true }).select('-password').exec();
  }

  async getFaculty(): Promise<User[]> {
    return this.userModel.find({ role: UserRole.FACULTY, isActive: true }).select('-password').exec();
  }

  async getCoordinators(): Promise<User[]> {
    return this.userModel.find({ role: UserRole.COORDINATOR, isActive: true }).select('-password').exec();
  }

  async update(id: string, updateUserDto: UpdateUserDto): Promise<User | null> {
    return this.userModel
      .findByIdAndUpdate(id, { ...updateUserDto, updatedAt: new Date() }, { new: true })
      .select('-password')
      .exec();
  }

  async deactivate(id: string): Promise<User | null> {
    return this.userModel
      .findByIdAndUpdate(id, { isActive: false, updatedAt: new Date() }, { new: true })
      .select('-password')
      .exec();
  }

  async validatePassword(user: User, password: string): Promise<boolean> {
    return bcrypt.compare(password, user.password);
  }

  async changePassword(id: string, newPassword: string): Promise<User | null> {
    const hashedPassword = await bcrypt.hash(newPassword, 10);
    return this.userModel
      .findByIdAndUpdate(id, { password: hashedPassword, updatedAt: new Date() }, { new: true })
      .select('-password')
      .exec();
  }
}