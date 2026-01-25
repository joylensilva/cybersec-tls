# Cybersec – Demonstração de Comunicação Segura (TLS e mTLS)

## !!!Observação!!!

Este projeto é exclusivamente para fins educacionais. Não altere o código-base para produção sem revisar práticas de segurança, políticas de certificados e configurações adequadas a ambientes reais.

## Objetivo

Projeto educacional para apoiar aulas sobre comunicação segura e criptografia, cobrindo conceitos como criptografia (simétrica/assimétrica), histórico, cifragem, hashing, PKI, ICP-Brasil, CAB Forum, OpenPGP e o protocolo SSL/TLS. A aplicação demonstra três cenários práticos com uma API Spring Boot:

- API sem TLS
- API com TLS (autenticação do servidor)
- API com mTLS (autenticação mútua: cliente e servidor)

## Tópicos Abordados

- Criptografia: fundamentos, simétrica e assimétrica
- Cifragem e Hashing: propósito e diferenças
- PKI: certificados X.509, AC (CA), cadeias de confiança
- ICP-Brasil e CAB Forum: padrões e governança
- OpenPGP: assinatura e criptografia de conteúdo
- SSL/TLS: handshake, certificados e canais seguros

## Estrutura do Projeto

```
cybersec/
├── HELP.md
├── mvnw / mvnw.cmd              # Maven Wrapper (Linux/macOS e Windows)
├── pom.xml                      # Build Maven (Java 21, Spring Boot)
├── README.md                    # Documentação do projeto
├── scripts/                     # Scripts passo a passo para demonstração
│   ├── 01-CreateCertificateAuthority.sh
│   ├── 02-GenerateServerCertificate.sh
│   ├── 03-CreateServerKeystore.sh
│   ├── 04-GenerateClientCertificate.sh
│   └── 05-CreateClientTruststore.sh
└── src/
		├── main/
		│   ├── java/br/com/cybersec/
		│   │   ├── CybersecApplication.java      # Classe principal
		│   │   └── HelloController.java          # Endpoints de demonstração
		│   └── resources/
		│       └── application.yaml              # Configurações TLS/mTLS (comentadas)
		└── test/
				└── java/br/com/cybersec/             # (espaço para testes)
```

## Endpoints da API

- `GET /hello` → conteúdo simples: "Hello Secure World!"
- `GET /hello-big-content` → conteúdo maior (útil para testar transferência segura)

## Execução (Sem TLS)

1) Requisitos:
- Java 21
- Maven (via Wrapper incluído)

2) Executar a aplicação (porta padrão 8080):

### Windows
```bash
mvnw.cmd spring-boot:run
```

### Linux/macOS
```bash
./mvnw spring-boot:run
```

3) Teste rápido (sem TLS):
```bash
curl http://localhost:8080/hello
curl http://localhost:8080/hello-big-content
```

## Habilitando TLS (Servidor autenticado)

Os scripts em `scripts/` automatizam a criação de uma CA, certificado do servidor e artefatos necessários. Execute-os em ordem para preparar o ambiente:

```bash
cd scripts
./01-CreateCertificateAuthority.sh
./02-GenerateServerCertificate.sh
./03-CreateServerKeystore.sh
```

Em seguida, habilite o TLS no arquivo de configuração [src/main/resources/application.yaml](src/main/resources/application.yaml):

```yaml
server:
  ssl:
    enabled: true
    key-store: classpath:server-keystore.p12
    key-store-password: changeit
    key-store-type: PKCS12
    key-alias: server
```

Observações:
- Garanta que o `server-keystore.p12` esteja acessível (por exemplo, no classpath ou forneça um caminho absoluto).
- Ajuste senhas e caminhos conforme os artefatos gerados pelos scripts.

Teste o TLS (cliente valida o servidor):
```bash
curl --cacert ca.crt https://localhost:8080/hello
```

## Habilitando mTLS (Autenticação mútua)

Execute os scripts para gerar o certificado do cliente e seu truststore:

```bash
cd scripts
./04-GenerateClientCertificate.sh
./05-CreateClientTruststore.sh
```

Ative a autenticação mútua no [src/main/resources/application.yaml](src/main/resources/application.yaml):

```yaml
server:
  ssl:
    enabled: true
    key-store: classpath:server-keystore.p12
    key-store-password: changeit
    key-store-type: PKCS12
    key-alias: server
    
    client-auth: need
    trust-store: classpath:client-truststore.p12
    trust-store-password: changeit
    trust-store-type: PKCS12
```

Teste o mTLS (cliente e servidor se autenticam):
```bash
curl --cert client.crt --key client.key --cacert ca.crt https://localhost:8080/hello
curl --cert client.crt --key client.key --cacert ca.crt https://localhost:8080/hello-big-content
```

Notas:
- `client.crt` e `client.key` devem corresponder ao cliente gerado e assinados pela mesma CA utilizada no servidor.
- `ca.crt` precisa ser a mesma CA que assinou ambos os certificados.

## Scripts de Demonstração (Passo a Passo)

A pasta `scripts/` contém os seguintes passos para uma aula/demonstração ao vivo:

1. `01-CreateCertificateAuthority.sh` – Cria a CA (Authority) para assinar certificados
2. `02-GenerateServerCertificate.sh` – Gera o certificado do servidor
3. `03-CreateServerKeystore.sh` – Cria o keystore do servidor (PKCS12)
4. `04-GenerateClientCertificate.sh` – Gera o certificado do cliente
5. `05-CreateClientTruststore.sh` – Cria o truststore do cliente (PKCS12)

Os scripts foram pensados para serem executados em sequência durante a aula, mostrando cada etapa da cadeia de confiança e da configuração do canal seguro.

Os arquivos de `keystore` e `truststore` devem ser copiados para a pasta `src\main\resources` assim que forem gerados, para serem usados pela configuração do projeto.

## Conceitos-Chave Demonstrados

- Certificados X.509, AC/CA e cadeia de confiança
- Keystore (chaves/certificados próprios) e Truststore (autoridades confiáveis)
- TLS (canal encriptado, servidor autenticado)
- mTLS (autenticação mútua cliente-servidor)

## Dicas e Troubleshooting

- Erro `curl` (ex.: código 58): geralmente indica problema de caminho/arquivo ou formato dos certificados. Verifique:
	- caminhos corretos para `--cert`, `--key` e `--cacert`
	- formatos dos arquivos (PEM vs DER) compatíveis com a ferramenta
	- correspondência entre certificados e a CA utilizada
- Ao alterar o `application.yaml`, reinicie a aplicação para aplicar as mudanças.
- Em Windows, recomenda-se usar Git Bash ou WSL para executar os `.sh`. Alternativamente, adapte os comandos para PowerShell.

## Tecnologias

- Spring Boot (Web MVC)
- Java 21
- Maven
- OpenSSL (para geração e manipulação de certificados)

## Uso em Sala de Aula

Este projeto permite que o instrutor:
- Explique conceitos de criptografia e PKI com exemplos práticos
- Demonstre a diferença entre tráfego sem TLS, com TLS e mTLS
- Mostre como certificados e cadeias de confiança impactam no handshake TLS
- Execute requisições de sucesso/falha ao vivo, reforçando o aprendizado

