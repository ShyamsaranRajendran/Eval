import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ReviewPhasesService } from './review-phases.service';
import { ReviewPhasesController } from './review-phases.controller';
import { ReviewPhase, ReviewPhaseSchema } from './schemas/review-phase.schema';

@Module({
  imports: [MongooseModule.forFeature([{ name: ReviewPhase.name, schema: ReviewPhaseSchema }])],
  controllers: [ReviewPhasesController],
  providers: [ReviewPhasesService],
  exports: [ReviewPhasesService],
})
export class ReviewPhasesModule {}