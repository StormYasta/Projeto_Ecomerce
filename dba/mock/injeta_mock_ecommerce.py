"""
injeta_mock_ecommerce.py

Injeta no SQL Server os dados do arquivo:
dados_mock_ecommerce_estatistica.xlsx

Tabelas alvo do projeto:
- TB_status_pessoa
- TB_pessoas
- TB_clientes
- TB_emails_pessoas
- TB_telefones_pessoas
- TB_enderecos_pessoas
- TB_fornecedores
- TB_produtos
- TB_status_pedido
- TB_pedidos
- TB_produtos_pedidos

Como usar:

1) Instale as dependências:
   pip install pandas openpyxl pyodbc

2) Rode com autenticação SQL Server:
   python injeta_mock_ecommerce.py --server localhost --database dev_projeto_fatec_ecomerce --user sa --password SUA_SENHA

3) Ou rode com autenticação do Windows:
   python injeta_mock_ecommerce.py --server localhost --database dev_projeto_fatec_ecomerce --trusted

4) Para limpar os dados mockados antes de inserir novamente:
   python injeta_mock_ecommerce.py --server localhost --database dev_projeto_fatec_ecomerce --user sa --password SUA_SENHA --reset

Observação:
- O banco e as tabelas precisam existir antes de rodar este script.
- Deixe o arquivo XLSX na mesma pasta do script, ou passe o caminho com --xlsx.
"""

from __future__ import annotations

import argparse
import math
import re
import unicodedata
from decimal import Decimal
from pathlib import Path
from typing import Any

import pandas as pd
import pyodbc


STATUS_PESSOA = ["ATIVO", "INATIVO", "SUSPENSO", "BLOQUEADO"]
STATUS_PEDIDO = ["PENDENTE", "EM PROCESSAMENTO", "ENVIADO", "ENTREGUE", "CANCELADO"]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Injeta dados mockados do e-commerce no SQL Server.")
    parser.add_argument("--xlsx", default="dados_mock_ecommerce_estatistica.xlsx", help="Caminho do arquivo XLSX.")
    parser.add_argument("--server", default="localhost", help="Servidor SQL Server. Ex: localhost, .\\SQLEXPRESS")
    parser.add_argument("--database", default="dev_projeto_fatec_ecomerce", help="Nome do banco de dados.")
    parser.add_argument("--driver", default="ODBC Driver 18 for SQL Server", help="Driver ODBC instalado.")
    parser.add_argument("--user", default=None, help="Usuário SQL Server. Ex: sa")
    parser.add_argument("--password", default=None, help="Senha SQL Server.")
    parser.add_argument("--trusted", action="store_true", help="Usar autenticação integrada do Windows.")
    parser.add_argument("--encrypt", default="no", choices=["yes", "no"], help="Encrypt na conexão ODBC.")
    parser.add_argument("--reset", action="store_true", help="Remove dados mockados antes de inserir novamente.")
    return parser.parse_args()


def connect(args: argparse.Namespace) -> pyodbc.Connection:
    if args.trusted:
        conn_str = (
            f"DRIVER={{{args.driver}}};"
            f"SERVER={args.server};"
            f"DATABASE={args.database};"
            "Trusted_Connection=yes;"
            f"Encrypt={args.encrypt};"
            "TrustServerCertificate=yes;"
        )
    else:
        if not args.user or not args.password:
            raise ValueError("Informe --user e --password, ou use --trusted para autenticação do Windows.")

        conn_str = (
            f"DRIVER={{{args.driver}}};"
            f"SERVER={args.server};"
            f"DATABASE={args.database};"
            f"UID={args.user};"
            f"PWD={args.password};"
            f"Encrypt={args.encrypt};"
            "TrustServerCertificate=yes;"
        )

    return pyodbc.connect(conn_str)


def clean_str(value: Any, default: str = "") -> str:
    if value is None:
        return default
    if isinstance(value, float) and math.isnan(value):
        return default
    return str(value).strip()


def only_digits(value: Any) -> str:
    return re.sub(r"\D", "", clean_str(value))


def to_decimal(value: Any, places: int = 2) -> Decimal:
    if value is None or (isinstance(value, float) and math.isnan(value)):
        value = 0
    return Decimal(str(round(float(value), places)))


def to_datetime(value: Any):
    if value is None or (isinstance(value, float) and math.isnan(value)):
        return None
    return pd.to_datetime(value).to_pydatetime()


def to_date(value: Any):
    dt = to_datetime(value)
    return None if dt is None else dt.date()


def strip_accents(text: str) -> str:
    text = unicodedata.normalize("NFKD", text)
    return "".join(ch for ch in text if not unicodedata.combining(ch))


def safe_email(email: str, fallback: str) -> str:
    email = strip_accents(clean_str(email).lower())
    email = email.replace(" ", "")
    if "@" not in email or "." not in email.split("@")[-1]:
        return fallback
    return email[:55]


def fake_cpf(cliente_id: int) -> str:
    # O CHECK do banco exige apenas 11 dígitos numéricos e unicidade.
    return f"900000{cliente_id:05d}"


def fake_cep(cliente_id: int) -> str:
    return f"{15000000 + cliente_id:08d}"


def fetch_map(cur: pyodbc.Cursor, table: str) -> dict[str, int]:
    cur.execute(f"SELECT id, descricao FROM {table}")
    return {row.descricao: int(row.id) for row in cur.fetchall()}


def ensure_statuses(cur: pyodbc.Cursor) -> tuple[dict[str, int], dict[str, int]]:
    for desc in STATUS_PESSOA:
        cur.execute(
            """
            IF NOT EXISTS (SELECT 1 FROM TB_status_pessoa WHERE descricao = ?)
                INSERT INTO TB_status_pessoa (descricao) VALUES (?);
            """,
            desc,
            desc,
        )

    for desc in STATUS_PEDIDO:
        cur.execute(
            """
            IF NOT EXISTS (SELECT 1 FROM TB_status_pedido WHERE descricao = ?)
                INSERT INTO TB_status_pedido (descricao) VALUES (?);
            """,
            desc,
            desc,
        )

    return fetch_map(cur, "TB_status_pessoa"), fetch_map(cur, "TB_status_pedido")


def exists_id(cur: pyodbc.Cursor, table: str, id_col: str, id_value: int) -> bool:
    cur.execute(f"SELECT 1 FROM {table} WHERE {id_col} = ?", id_value)
    return cur.fetchone() is not None


def insert_with_identity(cur: pyodbc.Cursor, table: str, sql: str, params: tuple[Any, ...]) -> None:
    cur.execute(f"SET IDENTITY_INSERT {table} ON;")
    try:
        cur.execute(sql, params)
    finally:
        cur.execute(f"SET IDENTITY_INSERT {table} OFF;")


def delete_by_ids(cur: pyodbc.Cursor, table: str, col: str, ids: list[int]) -> None:
    if not ids:
        return
    batch_size = 900
    for i in range(0, len(ids), batch_size):
        batch = ids[i : i + batch_size]
        placeholders = ",".join("?" for _ in batch)
        cur.execute(f"DELETE FROM {table} WHERE {col} IN ({placeholders})", batch)


def reset_mock_data(
    cur: pyodbc.Cursor,
    clientes: pd.DataFrame,
    fornecedores: pd.DataFrame,
    produtos: pd.DataFrame,
    pedidos: pd.DataFrame,
) -> None:
    cliente_ids = [int(x) for x in clientes["cliente_id"].tolist()]
    fornecedor_ids = [int(x) for x in fornecedores["fornecedor_id"].tolist()]
    produto_ids = [int(x) for x in produtos["produto_id"].tolist()]
    pedido_ids = [int(x) for x in pedidos["pedido_id"].tolist()]

    # Ordem respeitando FKs.
    delete_by_ids(cur, "TB_produtos_pedidos", "pedido_id", pedido_ids)
    delete_by_ids(cur, "TB_pedidos", "id", pedido_ids)
    delete_by_ids(cur, "TB_produtos", "id", produto_ids)
    delete_by_ids(cur, "TB_fornecedores", "id", fornecedor_ids)

    delete_by_ids(cur, "TB_emails_pessoas", "pessoa_id", cliente_ids)
    delete_by_ids(cur, "TB_telefones_pessoas", "pessoa_id", cliente_ids)
    delete_by_ids(cur, "TB_enderecos_pessoas", "pessoa_id", cliente_ids)
    delete_by_ids(cur, "TB_clientes", "pessoa_id", cliente_ids)
    delete_by_ids(cur, "TB_pessoas", "id", cliente_ids)


def upsert_clientes(cur: pyodbc.Cursor, clientes: pd.DataFrame, status_pessoa_map: dict[str, int]) -> None:
    for row in clientes.itertuples(index=False):
        cliente_id = int(row.cliente_id)
        nome = clean_str(row.nome)[:55]
        sobrenome = clean_str(row.sobrenome)[:55]
        cpf = fake_cpf(cliente_id)
        status_desc = clean_str(row.status_cliente, "ATIVO").upper()
        status_id = status_pessoa_map.get(status_desc, status_pessoa_map["ATIVO"])
        data_nascimento = to_date(row.data_nascimento)
        data_cadastro = to_datetime(row.data_cadastro)

        if exists_id(cur, "TB_pessoas", "id", cliente_id):
            cur.execute(
                """
                UPDATE TB_pessoas
                   SET nome = ?, sobrenome = ?, cpf = ?, status_id = ?,
                       data_cadastro = ?, data_nascimento = ?, updated_at = GETDATE()
                 WHERE id = ?;
                """,
                nome,
                sobrenome,
                cpf,
                status_id,
                data_cadastro,
                data_nascimento,
                cliente_id,
            )
        else:
            insert_with_identity(
                cur,
                "TB_pessoas",
                """
                INSERT INTO TB_pessoas
                    (id, nome, sobrenome, cpf, status_id, data_cadastro, data_nascimento)
                VALUES (?, ?, ?, ?, ?, ?, ?);
                """,
                (cliente_id, nome, sobrenome, cpf, status_id, data_cadastro, data_nascimento),
            )

        cur.execute(
            """
            IF NOT EXISTS (SELECT 1 FROM TB_clientes WHERE pessoa_id = ?)
                INSERT INTO TB_clientes (pessoa_id) VALUES (?);
            """,
            cliente_id,
            cliente_id,
        )

        email = safe_email(clean_str(row.email), f"cliente{cliente_id}@email.com")
        telefone = only_digits(row.telefone)[:15]
        if len(telefone) < 8:
            telefone = f"1799000{cliente_id:04d}"

        cur.execute(
            """
            IF EXISTS (SELECT 1 FROM TB_emails_pessoas WHERE pessoa_id = ? AND principal = 1)
                UPDATE TB_emails_pessoas SET email = ? WHERE pessoa_id = ? AND principal = 1;
            ELSE
                INSERT INTO TB_emails_pessoas (pessoa_id, email, principal) VALUES (?, ?, 1);
            """,
            cliente_id,
            email,
            cliente_id,
            cliente_id,
            email,
        )

        cur.execute(
            """
            IF EXISTS (SELECT 1 FROM TB_telefones_pessoas WHERE pessoa_id = ? AND principal = 1)
                UPDATE TB_telefones_pessoas SET telefone = ? WHERE pessoa_id = ? AND principal = 1;
            ELSE
                INSERT INTO TB_telefones_pessoas (pessoa_id, telefone, principal) VALUES (?, ?, 1);
            """,
            cliente_id,
            telefone,
            cliente_id,
            cliente_id,
            telefone,
        )

        uf = clean_str(row.uf_cliente, "SP").upper()[:2]
        cidade = clean_str(row.cidade_cliente, "São José do Rio Preto")[:255]
        cep = fake_cep(cliente_id)
        numero = str(100 + cliente_id)[:5]

        cur.execute(
            """
            IF EXISTS (SELECT 1 FROM TB_enderecos_pessoas WHERE pessoa_id = ? AND principal = 1)
                UPDATE TB_enderecos_pessoas
                   SET cep = ?, numero = ?, logradouro = ?, bairro = ?, cidade = ?, uf = ?, complemento = ?
                 WHERE pessoa_id = ? AND principal = 1;
            ELSE
                INSERT INTO TB_enderecos_pessoas
                    (pessoa_id, cep, numero, logradouro, bairro, cidade, uf, principal, complemento)
                VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?);
            """,
            cliente_id,
            cep,
            numero,
            f"Rua Mock {cliente_id}",
            "Centro",
            cidade,
            uf,
            "Gerado por mock estatístico",
            cliente_id,
            cliente_id,
            cep,
            numero,
            f"Rua Mock {cliente_id}",
            "Centro",
            cidade,
            uf,
            "Gerado por mock estatístico",
        )


def upsert_fornecedores(cur: pyodbc.Cursor, fornecedores: pd.DataFrame) -> None:
    for row in fornecedores.itertuples(index=False):
        fornecedor_id = int(row.fornecedor_id)
        nome = clean_str(row.fornecedor)[:255]
        cnpj = only_digits(row.cnpj)[:14]
        email = safe_email(clean_str(row.email), f"fornecedor{fornecedor_id}@email.com")
        telefone = only_digits(row.telefone)[:15]
        ativo = int(row.ativo)
        descricao = clean_str(row.descricao)[:255]

        if exists_id(cur, "TB_fornecedores", "id", fornecedor_id):
            cur.execute(
                """
                UPDATE TB_fornecedores
                   SET nome = ?, cnpj = ?, email = ?, telefone = ?, ativo = ?,
                       descricao = ?, updated_at = GETDATE(), deleted_at = NULL
                 WHERE id = ?;
                """,
                nome,
                cnpj,
                email,
                telefone,
                ativo,
                descricao,
                fornecedor_id,
            )
        else:
            insert_with_identity(
                cur,
                "TB_fornecedores",
                """
                INSERT INTO TB_fornecedores
                    (id, nome, cnpj, email, telefone, ativo, descricao)
                VALUES (?, ?, ?, ?, ?, ?, ?);
                """,
                (fornecedor_id, nome, cnpj, email, telefone, ativo, descricao),
            )


def upsert_produtos(cur: pyodbc.Cursor, produtos: pd.DataFrame) -> None:
    for row in produtos.itertuples(index=False):
        produto_id = int(row.produto_id)
        nome = clean_str(row.produto)[:255]
        descricao = clean_str(row.descricao, f"{nome} - produto mockado")[:1000]
        preco_venda = to_decimal(row.preco_venda)
        custo = to_decimal(row.custo_unitario)
        estoque = int(row.estoque)
        fornecedor_id = int(row.fornecedor_id)
        ativo = int(row.ativo)
        imagem_url = f"https://mock.local/produtos/{produto_id}.jpg"

        if exists_id(cur, "TB_produtos", "id", produto_id):
            cur.execute(
                """
                UPDATE TB_produtos
                   SET nome = ?, descricao = ?, preco_venda = ?, custo = ?, estoque = ?,
                       fornecedor_id = ?, ativo = ?, imagem_url = ?, updated_at = GETDATE(),
                       deleted_at = NULL
                 WHERE id = ?;
                """,
                nome,
                descricao,
                preco_venda,
                custo,
                estoque,
                fornecedor_id,
                ativo,
                imagem_url,
                produto_id,
            )
        else:
            insert_with_identity(
                cur,
                "TB_produtos",
                """
                INSERT INTO TB_produtos
                    (id, nome, descricao, preco_venda, custo, estoque, fornecedor_id, ativo, imagem_url)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
                """,
                (produto_id, nome, descricao, preco_venda, custo, estoque, fornecedor_id, ativo, imagem_url),
            )


def upsert_pedidos(cur: pyodbc.Cursor, pedidos: pd.DataFrame, status_pedido_map: dict[str, int]) -> None:
    for row in pedidos.itertuples(index=False):
        pedido_id = int(row.pedido_id)
        cliente_id = int(row.cliente_id)
        data_pedido = to_datetime(row.data_pedido)
        status_desc = clean_str(row.status_pedido, "PENDENTE").upper()
        status_id = status_pedido_map.get(status_desc, status_pedido_map["PENDENTE"])

        if exists_id(cur, "TB_pedidos", "id", pedido_id):
            cur.execute(
                """
                UPDATE TB_pedidos
                   SET cliente_id = ?, data_pedido = ?, status_id = ?
                 WHERE id = ?;
                """,
                cliente_id,
                data_pedido,
                status_id,
                pedido_id,
            )
        else:
            insert_with_identity(
                cur,
                "TB_pedidos",
                """
                INSERT INTO TB_pedidos (id, cliente_id, data_pedido, status_id)
                VALUES (?, ?, ?, ?);
                """,
                (pedido_id, cliente_id, data_pedido, status_id),
            )


def upsert_itens_pedido(cur: pyodbc.Cursor, itens: pd.DataFrame) -> None:
    for row in itens.itertuples(index=False):
        produto_id = int(row.produto_id)
        pedido_id = int(row.pedido_id)
        quantidade = int(row.quantidade)

        # No mock existem valor unitário e valor total.
        # Como a tabela TB_produtos_pedidos possui apenas "valor_pago",
        # aqui foi usado o valor pago unitário do item.
        valor_pago = to_decimal(row.valor_pago_unitario)

        cur.execute(
            """
            IF EXISTS (
                SELECT 1 FROM TB_produtos_pedidos
                 WHERE produto_id = ? AND pedido_id = ?
            )
                UPDATE TB_produtos_pedidos
                   SET quantidade = ?, valor_pago = ?
                 WHERE produto_id = ? AND pedido_id = ?;
            ELSE
                INSERT INTO TB_produtos_pedidos
                    (produto_id, pedido_id, quantidade, valor_pago)
                VALUES (?, ?, ?, ?);
            """,
            produto_id,
            pedido_id,
            quantidade,
            valor_pago,
            produto_id,
            pedido_id,
            produto_id,
            pedido_id,
            quantidade,
            valor_pago,
        )


def reseed_identity(cur: pyodbc.Cursor, table: str, id_col: str = "id") -> None:
    cur.execute(f"SELECT ISNULL(MAX({id_col}), 0) FROM {table};")
    max_id = int(cur.fetchone()[0])
    cur.execute(f"DBCC CHECKIDENT ('{table}', RESEED, {max_id});")


def main() -> None:
    args = parse_args()

    xlsx_path = Path(args.xlsx)
    if not xlsx_path.exists():
        raise FileNotFoundError(f"Arquivo não encontrado: {xlsx_path.resolve()}")

    print(f"Lendo arquivo: {xlsx_path.resolve()}")

    clientes = pd.read_excel(xlsx_path, sheet_name="Clientes")
    fornecedores = pd.read_excel(xlsx_path, sheet_name="Fornecedores")
    produtos = pd.read_excel(xlsx_path, sheet_name="Produtos")
    pedidos = pd.read_excel(xlsx_path, sheet_name="Pedidos")
    itens = pd.read_excel(xlsx_path, sheet_name="Itens_Pedido")

    conn = connect(args)
    conn.autocommit = False
    cur = conn.cursor()

    try:
        print("Garantindo status base...")
        status_pessoa_map, status_pedido_map = ensure_statuses(cur)

        if args.reset:
            print("Limpando dados mockados anteriores...")
            reset_mock_data(cur, clientes, fornecedores, produtos, pedidos)

        print("Inserindo/atualizando clientes...")
        upsert_clientes(cur, clientes, status_pessoa_map)

        print("Inserindo/atualizando fornecedores...")
        upsert_fornecedores(cur, fornecedores)

        print("Inserindo/atualizando produtos...")
        upsert_produtos(cur, produtos)

        print("Inserindo/atualizando pedidos...")
        upsert_pedidos(cur, pedidos, status_pedido_map)

        print("Inserindo/atualizando itens de pedido...")
        upsert_itens_pedido(cur, itens)

        print("Ajustando identity seeds...")
        reseed_identity(cur, "TB_pessoas")
        reseed_identity(cur, "TB_fornecedores")
        reseed_identity(cur, "TB_produtos")
        reseed_identity(cur, "TB_pedidos")

        conn.commit()

        print("\nConcluído com sucesso!")
        print(f"Clientes: {len(clientes)}")
        print(f"Fornecedores: {len(fornecedores)}")
        print(f"Produtos: {len(produtos)}")
        print(f"Pedidos: {len(pedidos)}")
        print(f"Itens de pedido: {len(itens)}")

    except Exception:
        conn.rollback()
        print("\nErro encontrado. Transação revertida.")
        raise

    finally:
        cur.close()
        conn.close()


if __name__ == "__main__":
    main()
