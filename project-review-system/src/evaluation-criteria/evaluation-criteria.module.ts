import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { EvaluationCriteriaService } from './evaluation-criteria.service';
import { EvaluationCriteriaController } from './evaluation-criteria.controller';
import { EvaluationCriteria, EvaluationCriteriaSchema } from './schemas/evaluation-criteria.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: EvaluationCriteria.name, schema: EvaluationCriteriaSchema }
    ])
  ],
  controllers: [EvaluationCriteriaController],
  providers: [EvaluationCriteriaService],
  exports: [EvaluationCriteriaService],
})
export class EvaluationCriteriaModule {}