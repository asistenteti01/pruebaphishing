# Etapa 1: Construir Gophish
FROM golang:1.17 as builder
WORKDIR /app
# Clona el repositorio oficial de Gophish
RUN git clone https://github.com/gophish/gophish.git .
# Compila el binario para Linux
RUN CGO_ENABLED=0 GOOS=linux go build -o gophish

# Etapa 2: Imagen final
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/gophish .
# Expone el puerto 80 (para la landing page) y 3333 (para el panel de administración)
EXPOSE 80 3333
# Inicia Gophish
CMD ["./gophish"]
