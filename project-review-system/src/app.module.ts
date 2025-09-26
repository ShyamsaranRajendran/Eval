import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { UserModule } from './user/user.module';
import { ProjectModule } from './project/project.module';
import { BatchModule } from './batch/batch.module';
import { PanelModule } from './panel/panel.module';
import { ReviewModule } from './review/review.module';
// import { FinalReportModule } from './final-report/final-report.module';

@Module({
  imports: [
    MongooseModule.forRoot('mongodb+srv://sarancode6:phwAi0IYGLd5aWQM@test-pro-db.bptyj9z.mongodb.net/Eval'),
    UserModule,
    ProjectModule,
    BatchModule,
    PanelModule,
    ReviewModule,
    // FinalReportModule,
  ],
})
export class AppModule {}