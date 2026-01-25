#!/bin/bash

# Removendo arquivos antigos, se existirem
rm -rf client-truststore.p12

# Cria o truststore em formato JKS com o certificado da CA
openssl pkcs12 -export \
 -nokeys \
 -in client.crt \
 -out client-truststore.p12 \
 -name "client" \
 -passout pass:changeit \
 -jdktrust anyExtendedKeyUsage