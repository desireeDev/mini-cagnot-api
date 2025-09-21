// Import des décorateurs et utilitaires de NestJS
import { Controller, Get, Param } from '@nestjs/common';

// Import du service qui contient la logique métier pour les clients
import { CustomersService } from './customers.service';

// Définition du contrôleur pour gérer les routes liées aux clients
// Préfixe des routes : '/customers'
@Controller('customers')
export class CustomersController {
  // Injection du service CustomersService via le constructeur
  constructor(private readonly customersService: CustomersService) {}

  /**
   * Route GET /customers/:id
   * Récupère un client par son ID
   * @param id - l'ID du client dans l'URL
   * @returns le client correspondant ou null si non trouvé
   */
  @Get(':id')
  getCustomer(@Param('id') id: string) {
    // Appelle la méthode findOne du service avec l'ID converti en nombre
    return this.customersService.findOne(Number(id));
  }

  /**
   * Route GET /customers
   * Récupère tous les clients
   * @returns tableau de tous les clients
   */
  @Get()
  getAll() {
    // Appelle la méthode findAll du service pour récupérer tous les clients
    return this.customersService.findAll();
  }
}
