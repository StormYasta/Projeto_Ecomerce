"""
merge_sql.py
------------
Percorre as subpastas indicadas dentro de uma pasta pai, lê todos os
arquivos .sql encontrados (em ordem alfabética) e concatena o conteúdo
em um único arquivo  db_full_create.sql  gerado na pasta pai.
"""

import os
import sys
import argparse
from pathlib import Path


def merge_sql_files(
    parent_folder: str,
    subfolders: list[str],
    output_filename: str = "db_full_create.sql",
    encoding: str = "utf-8",
) -> None:
    """
    Parâmetros
    ----------
    parent_folder   : Caminho absoluto ou relativo para a pasta pai.
    subfolders      : Lista com os nomes (ou caminhos relativos) das subpastas.
    output_filename : Nome do arquivo de saída gerado na pasta pai.
    encoding        : Codificação usada para leitura/escrita dos arquivos.
    """
    parent_path = Path(parent_folder).resolve()

    if not parent_path.is_dir():
        raise NotADirectoryError(f"Pasta pai não encontrada: {parent_path}")

    output_path = parent_path / output_filename

    total_files = 0

    with output_path.open("w", encoding=encoding) as output_file:
        for subfolder_name in subfolders:
            subfolder_path = parent_path / subfolder_name

            if not subfolder_path.is_dir():
                print(f"  [AVISO] Subpasta não encontrada, ignorada: {subfolder_path}")
                continue

            # Coleta e ordena os .sql da subpasta (não recursivo)
            sql_files = sorted(subfolder_path.glob("*.sql"))

            if not sql_files:
                print(f"  [INFO]  Nenhum .sql em: {subfolder_path}")
                continue

            # Cabeçalho de seção no arquivo de saída
            output_file.write(f"-- ============================================================\n")
            output_file.write(f"-- Subpasta: {subfolder_name}\n")
            output_file.write(f"-- ============================================================\n\n")

            for sql_file in sql_files:
                print(f"  [OK]    Processando: {sql_file.relative_to(parent_path)}")

                output_file.write(f"-- ------------------------------------------------------------\n")
                output_file.write(f"-- Arquivo: {sql_file.name}\n")
                output_file.write(f"-- ------------------------------------------------------------\n")

                content = sql_file.read_text(encoding=encoding)
                output_file.write(content)

                # Garante separador entre arquivos
                if not content.endswith("\n"):
                    output_file.write("\n")
                output_file.write("\n")

                total_files += 1

    print(f"\n✔  Concluído! {total_files} arquivo(s) combinado(s) em:\n   {output_path}")


# ---------------------------------------------------------------------------
# Interface de linha de comando
# ---------------------------------------------------------------------------

def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Combina arquivos .sql de subpastas em um único db_full_create.sql."
    )
    parser.add_argument(
        "parent_folder",
        help="Caminho até a pasta pai que contém as subpastas.",
    )
    parser.add_argument(
        "subfolders",
        nargs="+",
        help="Nome(s) das subpastas a serem processadas (separados por espaço).",
    )
    parser.add_argument(
        "--output",
        default="db_full_create.sql",
        help="Nome do arquivo de saída (padrão: db_full_create.sql).",
    )
    parser.add_argument(
        "--encoding",
        default="utf-8",
        help="Codificação dos arquivos (padrão: utf-8).",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    print(f"\nPasta pai  : {args.parent_folder}")
    print(f"Subpastas  : {args.subfolders}")
    print(f"Saída      : {args.output}")
    print(f"Encoding   : {args.encoding}\n")

    try:
        merge_sql_files(
            parent_folder=args.parent_folder,
            subfolders=args.subfolders,
            output_filename=args.output,
            encoding=args.encoding,
        )
    except Exception as exc:
        print(f"\n[ERRO] {exc}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()

# python merge_sql.py /caminho/pasta_pai subpasta1 subpasta2 subpasta3