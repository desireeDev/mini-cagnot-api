// auth.module.ts
import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { PrismaModule } from '../prisma.module'; // import du PrismaModule
import { JwtModule } from '@nestjs/jwt';

@Module({
  imports: [
    PrismaModule, // <- rend PrismaService disponible ici
    JwtModule.register({ secret: process.env.JWT_SECRET, signOptions: { expiresIn: '1h' } })
  ],
  providers: [AuthService],
  controllers: [AuthController],
})
export class AuthModule {}
