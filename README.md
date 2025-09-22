
🏆 LoyalNest – Mini Cagnot’ API

LoyalNest est une mini API de fidélité inspirée du concept Cagnot’.
👉 Chaque paiement effectué par un client génère automatiquement des points fidélité, sans action supplémentaire.

Tech stack : NestJS • TypeScript • Prisma • PostgreSQL • Docker

## ⚡ Installation rapide

```bash
# Cloner le projet
git clone https://github.com/desireedev/loyalnest.git
cd loyalnest

# Installer les dépendances
npm install

# Lancer la base et l’API avec Docker
docker-compose up --build
```
---

## 🔑 Endpoints principaux

### 1️⃣ Inscription

`POST /auth/signup`

```json
{ "name": "Alice", "email": "alice@mail.com", "password": "supersecret" }
```

### 2️⃣ Connexion

`POST /auth/login` → Retourne un JWT

```json
{ "email": "alice@mail.com", "password": "supersecret" }
```

### 3️⃣ Paiement

`POST /payments` *(Auth requise)*

```json
{ "customerId": 1, "amount": 50, "merchant": "Boulangerie Paul" }
```

### 4️⃣ Consulter un client

`GET /customers/1` *(Auth requise)*

```json
{ "id": 1, "name": "Alice", "email": "alice@mail.com", "points": 50 }
```

---

## 🌟 Pourquoi ce projet ?

* Démonstration de **NestJS + Prisma + Docker**
* Prototype rapide aligné avec la vision Cagnot’
* Montre la capacité à transformer une idée en **solution fonctionnelle


✨ Auteur : [Syntiche Attoh](https://desyportfolio.netlify.app/)


