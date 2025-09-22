// Import des décorateurs et exceptions de NestJS
import { Injectable, UnauthorizedException } from '@nestjs/common';

// Import du service Prisma pour interagir avec la base de données
import { PrismaService } from '../prisma.service';

// Import de bcrypt pour hasher et comparer les mots de passe
import * as bcrypt from 'bcrypt';

// Import du service JWT pour générer des tokens
import { JwtService } from '@nestjs/jwt';

// Import des DTO (Data Transfer Object) pour valider les données reçues
import { SignupDto } from './dto/signup.dto/signup.dto';
import { LoginDto } from './dto/login.dto/login.dto';

// Décorateur Injectable : permet d’injecter ce service dans d’autres parties de l’application
@Injectable()
export class AuthService {
  // Injection de PrismaService et JwtService dans le constructeur
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwt: JwtService,
  ) {}

  // Méthode pour inscrire un nouvel utilisateur
  async signup(data: SignupDto) {
    // Hash du mot de passe avec bcrypt (10 tours de salage)
    const hashed = await bcrypt.hash(data.password, 10);

    // Création de l'utilisateur dans la base via Prisma
    const user = await this.prisma.customer.create({
      data: { ...data, password: hashed }, // on stocke le mot de passe hashé
    });

    // Retourne un message et l’ID de l’utilisateur créé
    return { message: 'User registered successfully', userId: user.id };
  }

  // Méthode pour connecter un utilisateur
  async login(data: LoginDto) {
    // Recherche de l'utilisateur dans la base par email
    const user = await this.prisma.customer.findUnique({ where: { email: data.email } });

    // Vérification : si l'utilisateur n'existe pas ou si le mot de passe est incorrect
    if (!user || !(await bcrypt.compare(data.password, user.password))) {
      throw new UnauthorizedException('Invalid credentials'); // lève une exception
    }

    // Génération d’un token JWT contenant l’ID et l’email de l’utilisateur
    const token = this.jwt.sign({ sub: user.id, email: user.email });

    // Retourne le token au frontend
    return { access_token: token };
  }
}
