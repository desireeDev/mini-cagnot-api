import { IsEmail, IsString } from 'class-validator';
//Classe DTO pour la connexion:Données automatisées
export class LoginDto {
  @IsEmail()
  email: string;

  @IsString()
  password: string;
}
