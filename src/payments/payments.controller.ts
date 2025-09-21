import { Body, Controller, Post, Get, Put, Param } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { CreatePaymentDto } from './dto/payment.dto';
import { Payment } from '@prisma/client';

@Controller('payments')
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  /**
   * Endpoint POST /payments
   * Crée un nouveau paiement
   */
  @Post()
  create(@Body() dto: CreatePaymentDto) {
    return this.paymentsService.create(dto);
  }

  /**
   * Endpoint GET /payments
   * Récupère tous les paiements
   */
  @Get()
  getAll(): Promise<Payment[]> {
    return this.paymentsService.findAll();
  }

  /**
   * Endpoint GET /payments/:id
   * Récupère un paiement par son ID
   */
  @Get(':id')
  getById(@Param('id') id: string): Promise<Payment | null> {
    return this.paymentsService.findOne(Number(id));
  }

  /**
   * Endpoint PUT /payments/:id
   * Met à jour un paiement existant
   */
  @Put(':id')
  update(
    @Param('id') id: string,
    @Body() dto: Partial<CreatePaymentDto>, // On peut mettre à jour un ou plusieurs champs
  ): Promise<Payment> {
    return this.paymentsService.update(Number(id), dto);
  }
}
