package com.projeto.fatec.classes.pessoa.status;

public class StatusPessoEnum {
    public enum StatusPessoa {

        ATIVO(1, "ATIVO"),
        INATIVO(2, "INATIVO"),
        SUSPENSO(3, "SUSPENSO"),
        BLOQUEADO(4, "BLOQUEADO");

        private final int id;
        private final String descricao;

        StatusPessoa(int id, String descricao) {
            this.id = id;
            this.descricao = descricao;
        }

        public int getId() {
            return id;
        }

        public String getDescricao() {
            return descricao;
        }
    }
}
