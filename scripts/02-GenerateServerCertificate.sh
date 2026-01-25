#!/bin/bash

# Removendo arquivos antigos, se existirem
rm -f server.key server.csr server.crt ca.srl

# Cria a chave privada do servidor
openssl genrsa -out server.key 2048

# Desabilita a conversão de caminhos do MSYS no Windows para evitar problemas com o OpenSSL em ambientes Git Bash
export MSYS_NO_PATHCONV=1
# Gera a CSR (Certificate Signing Request) do servidor
openssl req \
 -new \
 -key server.key \
 -out server.csr \
 -subj "/C=BR/ST=Sao Paulo/L=Sao Paulo/O=Cybersec Server/OU=MBA/CN=localhost" \
 -addext "subjectAltName=DNS:localhost,DNS:server,IP:127.0.0.1" \
 -addext "basicConstraints=CA:FALSE" \
 -addext "keyUsage=digitalSignature,keyEncipherment" \
 -addext "extendedKeyUsage=serverAuth"

# subjectAltName especifica os nomes alternativos do sujeito (SANs) para o certificado
# DNS:localhost e DNS:server permitem que o certificado seja válido para esses nomes de domínio
# IP:127.0.0.1 permite que o certificado seja válido para esse endereço IP

# basicConstraints indica o papel do certificado (CA ou end-entity)
# CA:FALSE indica que este certificado não é de uma Autoridade Certificadora

# keyUsage define os usos permitidos para a chave pública do certificado
# digitalSignature permite que a chave seja usada para assinar digitalmente dados
# keyEncipherment permite que a chave seja usada para troca de chaves

# extendedKeyUsage define usos adicionais específicos para o certificado
# serverAuth indica que o certificado pode ser usado para autenticação de servidor em TLS/SSL

# Opcional: Exibe o conteúdo da CSR para verificação
# openssl req -in server.csr -noout -text

# Assina a CSR do servidor com a CA para gerar o certificado do servidor
openssl x509 \
 -req \
 -in server.csr \
 -CA ca.crt \
 -CAkey ca.key \
 -CAcreateserial \
 -out server.crt \
 -days 365 \
 -copy_extensions copy

# -CAcreateserial cria o arquivo de número de série da CA se ele não existir
# -copy_extensions copy copia as extensões da CSR para o certificado assinado
# Existem outras opções para gerenciar extensões, como usar um arquivo de configuração do OpenSSL
# Por exemplo, você pode usar -extfile e -extensions para especificar extensões personalizadas
# conforme o formato definido no arquivo de configuração do OpenSSL de exemplo abaixo:
# [ v3_req ]
# authorityKeyIdentifier=keyid,issuer
# basicConstraints=CA:FALSE
# keyUsage=digitalSignature,keyEncipherment
# extendedKeyUsage=serverAuth
# subjectAltName=@alt_names
#
# [ alt_names ]
# DNS.1=localhost
# DNS.2=server
# DNS.3=api.local
# IP.1=127.0.0.1
# IP.2=192.168.0.10