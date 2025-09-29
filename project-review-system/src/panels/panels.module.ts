import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { PanelsService } from './panels.service';
import { PanelsController } from './panels.controller';
import { Panel, PanelSchema } from './schemas/panel.schema';

@Module({
  imports: [MongooseModule.forFeature([{ name: Panel.name, schema: PanelSchema }])],
  controllers: [PanelsController],
  providers: [PanelsService],
  exports: [PanelsService],
})
export class PanelsModule {}