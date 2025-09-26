import { Controller, Get, Post, Put, Delete, Param, Body } from '@nestjs/common';
import { BatchService } from './batch.service';
import { Batch } from './schemas/batch.schema';

@Controller('batches')
export class BatchController {
  constructor(private readonly batchService: BatchService) {}

  @Post()
  async create(@Body() createBatchDto: any): Promise<Batch> {
    return this.batchService.create(createBatchDto);
  }

  @Get()
  async findAll(): Promise<Batch[]> {
    return this.batchService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<Batch | null> {
    return this.batchService.findOne(id);
  }

  @Get('department/:department')
  async findByDepartment(@Param('department') department: string): Promise<Batch[]> {
    return this.batchService.findByDepartment(department);
  }

  @Get('year/:year')
  async findByYear(@Param('year') year: string): Promise<Batch[]> {
    return this.batchService.findByYear(parseInt(year));
  }

  @Put(':id')
  async update(@Param('id') id: string, @Body() updateBatchDto: any): Promise<Batch | null> {
    return this.batchService.update(id, updateBatchDto);
  }

  @Delete(':id')
  async remove(@Param('id') id: string): Promise<Batch | null> {
    return this.batchService.remove(id);
  }
}