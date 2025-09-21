import { IsInt, IsNotEmpty, IsNumber, IsString, Min } from 'class-validator';

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
