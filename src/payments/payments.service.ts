import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { CreatePaymentDto } from './dto/payment.dto';
import { Payment } from '@prisma/client';

@Injectable()
// Service pour gérer les paiements et la mise à jour des points des clients
export class PaymentsService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Crée un paiement et met à jour les points du client
   * @param data - données du paiement
   * @returns le paiement créé avec les points gagnés et total de points
   */
  async create(data: CreatePaymentDto) {
    const pointsEarned = Math.floor(data.amount);

    // Création du paiement dans la base
    const payment = await this.prisma.payment.create({
      data: {
        amount: data.amount,
        merchant: data.merchant,
        customerId: data.customerId,
      },
    });

    // Mise à jour des points du client
    const updatedCustomer = await this.prisma.customer.update({
      where: { id: data.customerId },
      data: { points: { increment: pointsEarned } },
      select: { id: true, points: true }, // On récupère le total des points
    });

    return { ...payment, pointsEarned, totalPoints: updatedCustomer.points };
  }

  /**
   * Récupère un paiement par son ID
   * @param id - ID du paiement
   * @returns le paiement ou null si non trouvé
   */
  async findOne(id: number): Promise<Payment | null> {
    return this.prisma.payment.findUnique({ where: { id } });
  }

  /**
   * Récupère tous les paiements
   * @returns tableau de paiements
   */
  async findAll(): Promise<Payment[]> {
    return this.prisma.payment.findMany();
  }

  /**
   * Met à jour un paiement existant
   * @param id - ID du paiement
   * @param data - champs à mettre à jour (amount, merchant)
   * @returns le paiement mis à jour
   */
  async update(
    id: number,
    data: Partial<Omit<CreatePaymentDto, 'customerId'>>, // On ne peut pas changer le client
  ): Promise<Payment> {
    const existingPayment = await this.prisma.payment.findUnique({
      where: { id },
    });
    if (!existingPayment) {
      throw new NotFoundException(`Payment with ID ${id} not found`);
    }

    return this.prisma.payment.update({
      where: { id },
      data,
    });
  }

  /**
   * Annule un paiement et retire les points du client
   * @param id - ID du paiement
   * @returns le paiement supprimé et points retirés
   */
  async remove(id: number) {
    // Vérifie si le paiement existe
    const payment = await this.prisma.payment.findUnique({ where: { id } });
    if (!payment) {
      throw new NotFoundException(`Payment with ID ${id} not found`);
    }

    const pointsToRemove = Math.floor(payment.amount);

    // Supprime le paiement
    await this.prisma.payment.delete({ where: { id } });

    // Retire les points au client
    const updatedCustomer = await this.prisma.customer.update({
      where: { id: payment.customerId },
      data: { points: { decrement: pointsToRemove } },
      select: { id: true, points: true },
    });

    return {
      message: 'Payment cancelled and points removed',
      removedPaymentId: payment.id,
      pointsRemoved: pointsToRemove,
      totalPoints: updatedCustomer.points,
    };
  }
}
