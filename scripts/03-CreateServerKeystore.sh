#!/bin/bash

# Removendo arquivos antigos, se existirem
rm -rf server-keystore.p12

# Cria o keystore em formato JKS com o certificado e a chave privada do servidor
openssl pkcs12 -export \
 -in server.crt \
 -inkey server.key \
 -out server-keystore.p12 \
 -name "server" \
 -passout pass:changeit

