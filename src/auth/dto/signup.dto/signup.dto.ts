import { IsEmail, IsNotEmpty, IsString, MinLength } from 'class-validator';
//Classe DTO pour l'inscription : Données automatisées
export class SignupDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsEmail()
  email: string;

  @IsString()
  @MinLength(6)
  password: string;
}
