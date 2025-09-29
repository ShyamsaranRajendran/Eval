import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AssignmentsService } from './assignments.service';
import { AssignmentsController } from './assignments.controller';
import { StudentPanelAssignment, StudentPanelAssignmentSchema } from './schemas/student-panel-assignment.schema';
import { EvaluatorPanelAssignment, EvaluatorPanelAssignmentSchema } from './schemas/evaluator-panel-assignment.schema';
import { PanelsModule } from '../panels/panels.module';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: StudentPanelAssignment.name, schema: StudentPanelAssignmentSchema },
      { name: EvaluatorPanelAssignment.name, schema: EvaluatorPanelAssignmentSchema }
    ]),
    PanelsModule
  ],
  controllers: [AssignmentsController],
  providers: [AssignmentsService],
  exports: [AssignmentsService],
})
export class AssignmentsModule {}