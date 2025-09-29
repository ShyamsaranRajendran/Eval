import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ReportsService } from './reports.service';
import { ReportsController } from './reports.controller';
import { Student, StudentSchema } from '../students/schemas/student.schema';
import { Evaluation, EvaluationSchema } from '../evaluations/schemas/evaluation.schema';
import { Panel, PanelSchema } from '../panels/schemas/panel.schema';
import { ReviewPhase, ReviewPhaseSchema } from '../review-phases/schemas/review-phase.schema';
import { EvaluationCriteria, EvaluationCriteriaSchema } from '../evaluation-criteria/schemas/evaluation-criteria.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Student.name, schema: StudentSchema },
      { name: Evaluation.name, schema: EvaluationSchema },
      { name: Panel.name, schema: PanelSchema },
      { name: ReviewPhase.name, schema: ReviewPhaseSchema },
      { name: EvaluationCriteria.name, schema: EvaluationCriteriaSchema }
    ])
  ],
  controllers: [ReportsController],
  providers: [ReportsService],
  exports: [ReportsService],
})
export class ReportsModule {}