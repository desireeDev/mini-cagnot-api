import { IsInt, IsNotEmpty, IsNumber, IsString, Min } from 'class-validator';
//Spécification des données acceptées pour la création d'un paiement
export class CreatePaymentDto {
  @IsInt()
  customerId: number;

  @IsNumber()
  @Min(0.1)
  amount: number;

  @IsString()
  @IsNotEmpty()
  merchant: string;
}
