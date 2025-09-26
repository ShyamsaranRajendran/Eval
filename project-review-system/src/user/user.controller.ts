import { Controller, Get, Post, Put, Delete, Param, Body ,UnauthorizedException } from '@nestjs/common';
import { UserService } from './user.service';
import { User } from './schemas/user.schema';

@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post()
  async create(@Body() createUserDto: any): Promise<User> {
    return this.userService.create(createUserDto);
  }

  @Post('login')
  async login(@Body() body: { email: string; password: string }): Promise<any> {
    const user = await this.userService.validateUser(body.email, body.password);
    if (!user) {
      throw new UnauthorizedException('Invalid email or password');
    }

    return {
      message: 'Login successful',
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
    };
  }

  @Get()
  async findAll(): Promise<User[]> {
    return this.userService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<User | null> {
    return this.userService.findOne(id);
  }

  @Get('role/:role')
  async findByRole(@Param('role') role: string): Promise<User[]> {
    return this.userService.findByRole(role);
  }

  @Put(':id')
  async update(@Param('id') id: string, @Body() updateUserDto: any): Promise<User | null> {
    return this.userService.update(id, updateUserDto);
  }

  @Delete(':id')
  async remove(@Param('id') id: string): Promise<User | null> {
    return this.userService.remove(id);
  }
}
