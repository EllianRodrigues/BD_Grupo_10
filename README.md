 # Banco de Dados - Grupo 10

## Pré-requisitos
- Instalar e executar o Docker Desktop (ou Docker Engine).

## 1) Quick start

1. Clone o repositório:

```powershell
git clone <URL-DO-REPOSITORIO>
cd "Banco De Dados - Grupo 10"
```

2. Crie um arquivo `.env` na raiz (o projeto carrega variáveis de ambiente a partir dele). Exemplo mínimo:

```env
# PostgreSQL
POSTGRES_USER=appuser
POSTGRES_PASSWORD=umasenhaboa123
POSTGRES_DB=meubancodedados
# Porta externa para mapear o PostgreSQL (ex.: 64321)
POSTGRES_PORT_EXTERNAL=64321

# pgAdmin
PGADMIN_DEFAULT_EMAIL=pgadmin@meuprojeto.com
PGADMIN_DEFAULT_PASSWORD=outrasenhaboa456
PGADMIN_PORT_EXTERNAL=6080
```

**Dica:** crie o arquivo `.env` e (opcionalmente) crie um ambiente virtual Python antes de instalar as dependências. Exemplo em PowerShell:

```powershell
# cria o venv na pasta .venv
python -m venv .venv
# ativa o venv (PowerShell)
.\.venv\Scripts\Activate.ps1
# por fim, instale as dependências
pip install -r .\requirements.txt
```

3. Inicie os serviços:

```powershell
docker compose up -d
```

4. Verifique os containers:

```powershell
docker compose ps
```

## 2) Serviços e portas
- pgAdmin (interface web): `http://localhost:6080` (porta externa configurada por `PGADMIN_PORT_EXTERNAL`).
- PostgreSQL: porta externa configurada por `POSTGRES_PORT_EXTERNAL` (ex.: `localhost:64321`) que mapeia a porta interna `5432` do container.

Os valores reais dependem do seu `.env` — verifique antes de conectar.

## 3) Acessando o PostgreSQL via pgAdmin

1. Acesse `http://localhost:<PGADMIN_PORT_EXTERNAL>` e faça login com `PGADMIN_DEFAULT_EMAIL` / `PGADMIN_DEFAULT_PASSWORD`.
2. Se o servidor PostgreSQL não for registrado automaticamente, adicione um novo servidor (Add New Server) com as seguintes configurações na aba "Connection":

- **Host name/address:** `postgres_db` (nome do serviço no `docker-compose`), ou `host.docker.internal` / `localhost` com a porta externa se preferir conectar externamente.
- **Port:** `5432` (porta interna do container) — se conectar via `localhost` use `POSTGRES_PORT_EXTERNAL`.
- **Maintenance database:** o valor de `POSTGRES_DB`.
- **Username / Password:** `POSTGRES_USER` e `POSTGRES_PASSWORD` do `.env`.

## 4) Script de inicialização
O arquivo `init.sql` na raiz do repositório é executado na primeira inicialização do container PostgreSQL para criar tabelas e dados iniciais. Verifique e ajuste `init.sql` conforme necessário.

## 5) Persistência de dados
A pasta `data/` contém os arquivos do cluster PostgreSQL (diretório de dados). Evite editar estes arquivos manualmente — pare os containers antes de qualquer alteração direta.

Para parar os containers (mantendo os dados):

```powershell
docker compose down
```

Para remover volumes e limpar dados persistentes (CUIDADO — isto apaga o banco):

```powershell
docker compose down -v
```

## 6) Rodando as consultas (Python)

O repositório inclui um script Python chamado `querry.py` que carrega automaticamente as variáveis do arquivo `.env` e executa as consultas definidas. Após garantir que o `.env` existe e as dependências estão instaladas, execute:

```powershell
python .\querry.py
```
