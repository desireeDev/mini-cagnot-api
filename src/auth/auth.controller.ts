// Import des décorateurs et types de NestJS
import { Body, Controller, Post } from '@nestjs/common';

// Import du service d'authentification qui contient la logique métier
import { AuthService } from './auth.service';

// Import des DTO pour valider les données entrantes
import { SignupDto } from './dto/signup.dto/signup.dto';
import { LoginDto } from './dto/login.dto/login.dto';

// Définition du contrôleur pour gérer les routes liées à l'authentification
// Préfixe des routes : '/auth'
@Controller('auth')
export class AuthController {
  // Injection du service AuthService via le constructeur
  constructor(private readonly authService: AuthService) {}

  // Route POST /auth/signup
  // Permet de créer un nouvel utilisateur
  @Post('signup')
  signup(@Body() dto: SignupDto) {
    // Appelle la méthode signup du service pour traiter l'inscription
    return this.authService.signup(dto);
  }

  // Route POST /auth/login
  // Permet de connecter un utilisateur existant
  @Post('login')
  login(@Body() dto: LoginDto) {
    // Appelle la méthode login du service pour vérifier les identifiants et générer un JWT
    return this.authService.login(dto);
  }
}
