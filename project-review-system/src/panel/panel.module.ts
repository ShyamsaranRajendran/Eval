import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { PanelService } from './panel.service';
import { PanelController } from './panel.controller';
import { Panel, PanelSchema } from './schemas/panel.schema';

@Module({
  imports: [MongooseModule.forFeature([{ name: Panel.name, schema: PanelSchema }])],
  controllers: [PanelController],
  providers: [PanelService],
  exports: [PanelService],
})
export class PanelModule {}