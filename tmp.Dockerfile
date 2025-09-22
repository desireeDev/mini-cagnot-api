FROM node:18
WORKDIR /app
# Installer les dépendances
COPY package*.json ./
RUN npm install
COPY . .
# Installer Prisma et générer le client
RUN npm install prisma --save-dev
RUN npx prisma generate --schema=./prisma/schema.prisma
# Installer le client PostgreSQL pour pg_isready
RUN apt-get update && apt-get install -y postgresql-client
# Construire l'application
RUN npm run build
EXPOSE 3000

# Exécuter wait-for-postgres puis lancer prisma db push et enfin NestJS
CMD ["sh", "-c", "./wait-for-postgres.sh db && npx prisma db push && npm run start:prod"]
