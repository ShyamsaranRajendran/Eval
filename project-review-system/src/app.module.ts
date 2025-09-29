import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

// Import all new modules
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { ReviewPhasesModule } from './review-phases/review-phases.module';
import { EvaluationCriteriaModule } from './evaluation-criteria/evaluation-criteria.module';
import { StudentsModule } from './students/students.module';
import { PanelsModule } from './panels/panels.module';
import { EvaluationsModule } from './evaluations/evaluations.module';
import { AssignmentsModule } from './assignments/assignments.module';
import { ReportsModule } from './reports/reports.module';

@Module({
  imports: [
    MongooseModule.forRoot('mongodb+srv://sarancode6:phwAi0IYGLd5aWQM@test-pro-db.bptyj9z.mongodb.net/Eval'),
    AuthModule,
    UsersModule,
    ReviewPhasesModule,
    EvaluationCriteriaModule,
    StudentsModule,
    PanelsModule,
    EvaluationsModule,
    AssignmentsModule,
    ReportsModule,
  ],
})
export class AppModule {}