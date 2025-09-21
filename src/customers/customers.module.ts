// customers.module.ts
import { Module } from '@nestjs/common';
import { CustomersService } from './customers.service';
import { CustomersController } from './customers.controller';
import { PrismaModule } from '../prisma.module'; // importer PrismaModule

@Module({
  imports: [PrismaModule], // <- rend PrismaService disponible pour CustomersService
  providers: [CustomersService],
  controllers: [CustomersController],
})
export class CustomersModule {}
