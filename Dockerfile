FROM node:18-bullseye

WORKDIR /app

# Instalar un servidor web simple
RUN npm install -g http-server

COPY index.html .
COPY favicon.ico . || true

EXPOSE 80

CMD ["http-server", "-p", "80", "--cors"]
