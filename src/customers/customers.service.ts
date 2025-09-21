import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { Customer } from '@prisma/client'; // Type généré par Prisma pour le modèle Customer

@Injectable()
export class CustomersService {
  // Injection du service Prisma
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Récupère un client par son ID
   * @param id - ID du client
   * @returns le client ou null si non trouvé
   */
  findOne(id: number): Promise<Customer | null> {
    return this.prisma.customer.findUnique({ where: { id } });
  }

  /**
   * Récupère tous les clients
   * @returns tableau de clients
   */
  async findAll(): Promise<Customer[]> {
    return this.prisma.customer.findMany();
  }

  /**
   * Met à jour un client existant
   * @param id - ID du client
   * @param data - champs à mettre à jour
   * @returns le client mis à jour
   */
  async update(
    id: number,
    data: Partial<Omit<Customer, 'id'>>, // tous les champs sauf l'ID
  ): Promise<Customer> {
    return this.prisma.customer.update({ where: { id }, data });
  }

  /**
   * Supprime un client
   * @param id - ID du client
   * @returns le client supprimé
   */
  async remove(id: number): Promise<Customer> {
    return this.prisma.customer.delete({ where: { id } });
  }
}
