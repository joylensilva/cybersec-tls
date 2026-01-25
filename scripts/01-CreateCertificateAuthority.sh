#!/bin/bash

# Removendo arquivos antigos, se existirem
rm -rf ca.key ca.crt

# Cria a chave privada da CA
openssl genrsa -out ca.key 4096

# Desabilita a conversão de caminhos do MSYS no Windows para evitar problemas com o OpenSSL em ambientes Git Bash
export MSYS_NO_PATHCONV=1
# Cria o certificado autoassinado da CA
openssl req \
 -new \
 -x509 \
 -days 365 \
 -key ca.key \
 -out ca.crt \
 -subj "/C=BR/ST=Sao Paulo/L=Sao Paulo/O=Cybersec CA/OU=MBA/CN=Cybersec Root CA" \
 -addext "basicConstraints=CA:TRUE,pathlen:0" \
 -addext "keyUsage=cRLSign,keyCertSign"

# basicContraints indica o papel do certificado (CA ou end-entity)
# CA:TRUE indica que este certificado é de uma Autoridade Certificadora
# pathlen:0 indica que esta CA não pode emitir certificados para outras CAs (apenas para entidades finais)

# keyUsage define os usos permitidos para a chave pública do certificado
# cRLSign permite que a CA assine Listas de Revogação de Certificados (CRLs)
# keyCertSign permite que a CA assine outros certificados