# Etapa 1: Construir Gophish usando una imagen Debian (buster) para soporte completo de CGO
FROM golang:1.17-buster as builder
WORKDIR /app

# Instalar dependencias necesarias para compilar sqlite3 (libsqlite3-dev)
RUN apt-get update && apt-get install -y sqlite3 libsqlite3-dev

# Clonar el repositorio oficial de Gophish
RUN git clone https://github.com/gophish/gophish.git .

# Compilar el binario para Linux con CGO habilitado
RUN CGO_ENABLED=1 GOOS=linux go build -o gophish

# Etapa 2: Imagen final
FROM debian:stable-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /root/

# Copiar el binario desde la etapa de builder
COPY --from=builder /app/gophish .

# Exponer puertos: 80 para la landing page y 3333 para el panel de administración
EXPOSE 80 3333

# Comando para iniciar Gophish
CMD ["./gophish"]
