#!/bin/bash

# Removendo arquivos antigos, se existirem
rm -f client.key client.csr client.crt

# Cria a chave privada do servidor
openssl genrsa -out client.key 2048

# Desabilita a conversão de caminhos do MSYS no Windows para evitar problemas com o OpenSSL em ambientes Git Bash
export MSYS_NO_PATHCONV=1
# Gera a CSR (Certificate Signing Request) do cliente
openssl req \
 -new \
 -key client.key \
 -out client.csr \
 -subj "/C=BR/ST=Sao Paulo/L=Sao Paulo/O=Cybersec Client/OU=MBA/CN=client" \
 -addext "subjectAltName=DNS:localhost,DNS:client,IP:127.0.0.1" \
 -addext "basicConstraints=CA:FALSE" \
 -addext "keyUsage=digitalSignature,keyEncipherment" \
 -addext "extendedKeyUsage=clientAuth"

# Assina a CSR do cliente com a CA para gerar o certificado do cliente
openssl x509 \
 -req \
 -in client.csr \
 -CA ca.crt \
 -CAkey ca.key \
 -out client.crt \
 -days 365 \
 -copy_extensions copy