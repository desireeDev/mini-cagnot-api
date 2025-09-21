import { Module } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { PaymentsController } from './payments.controller';
import { PrismaModule } from '../prisma.module'; // importer PrismaModule

@Module({
  imports: [PrismaModule], // <- rend PrismaService disponible pour PaymentsService
  providers: [PaymentsService],
  controllers: [PaymentsController],
})
export class PaymentsModule {}
