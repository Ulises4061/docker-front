FROM node:18-bullseye

WORKDIR /app

# Instalar http-server globalmente
RUN npm install -g http-server

# Copiar archivos estáticos
COPY index.html .
COPY package.json .
COPY .env . || true

EXPOSE 80

# Servir la aplicación
CMD ["http-server", "-p", "80", "--cors"]
