import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User, UserDocument } from './schemas/user.schema';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UserService {
  constructor(
    @InjectModel(User.name) private userModel: Model<UserDocument>,
  ) {}

  async create(createUserDto: any): Promise<User> {
    if (!createUserDto.password) {
      throw new Error('Password is required');
    }

    // hash password
    const hashedPassword = await bcrypt.hash(createUserDto.password, 10);

    // save only passwordHash, not raw password
    const createdUser = new this.userModel({
      name: createUserDto.name,
      email: createUserDto.email,
      role: createUserDto.role,
      password: hashedPassword,
    });

    return createdUser.save();
  }

  async findAll(): Promise<User[]> {
    return this.userModel.find().exec();
  }

  async findOne(id: string): Promise<User | null> {
    return this.userModel.findById(id).exec();
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.userModel.findOne({ email }).exec();
  }

  async validateUser(email: string, password: string): Promise<User> {
    const user = await this.findByEmail(email);
    if (!user) throw new UnauthorizedException('Invalid email or password');

    // compare bcrypt hash
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) throw new UnauthorizedException('Invalid email or password');

    return user;
  }

  async findByRole(role: string): Promise<User[]> {
    return this.userModel.find({ role }).exec();
  }

  async update(id: string, updateUserDto: any): Promise<User | null> {
    if (updateUserDto.password) {
      updateUserDto.passwordHash = await bcrypt.hash(updateUserDto.password, 10);
      delete updateUserDto.password;
    }
    return this.userModel.findByIdAndUpdate(id, updateUserDto, { new: true }).exec();
  }

  async remove(id: string): Promise<User | null> {
    return this.userModel.findByIdAndDelete(id).exec();
  }
}
