## preparation
# image node.js légère 
FROM node:20-alpine AS build

# définit /app comme dossier de travail dans le conteneur
WORKDIR /app

# copie les fichier package.json
COPY package*.json ./
# installe les dépendances
run npm ci

# copy tout le code angular
COPY . .
# build angular
RUN npm run build

## serveur web
# nouvelle image  encore plus légère (on ne build rien dans celle ci)
FROM nginx:alpine



# Copie la configuration nginx
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# on utilise les fichier build de la 1er image
COPY --from=build /app/dist/olympic-games-starter/browser /app

# le conteneur écoute le port 80
EXPOSE 80

# lance nginx en premier plan
CMD ["nginx", "-g", "daemon off;"]