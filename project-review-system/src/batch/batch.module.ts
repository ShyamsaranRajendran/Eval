import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { BatchService } from './batch.service';
import { BatchController } from './batch.controller';
import { Batch, BatchSchema } from './schemas/batch.schema';
import { UserModule } from '../user/user.module';
@Module({
  imports: [MongooseModule.forFeature([{ name: Batch.name, schema: BatchSchema }]),
  UserModule ],
  controllers: [BatchController],
  providers: [BatchService],
  exports: [BatchService],
})
export class BatchModule {}