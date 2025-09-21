// prisma.module.ts
import { Module } from '@nestjs/common';
import { PrismaService } from './prisma.service'; // ton fichier serviceprisma.ts

@Module({
  providers: [PrismaService],
  exports: [PrismaService], // rend PrismaService disponible dans d'autres modules
})
export class PrismaModule {}
