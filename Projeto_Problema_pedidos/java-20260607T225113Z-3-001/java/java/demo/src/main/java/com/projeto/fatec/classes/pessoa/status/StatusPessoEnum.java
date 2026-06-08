package com.projeto.fatec.classes.pessoa.status;

public class StatusPessoEnum {
    public enum StatusPessoa {

        ATIVO(1, "ATIVO"),
        INATIVO(2, "INATIVO"),
        SUSPENSO(3, "SUSPENSO"),
        BLOQUEADO(4, "BLOQUEADO");

        private final Integer id;
        private final String descricao;

        StatusPessoa(Integer id, String descricao) {
            this.id = id;
            this.descricao = descricao;
        }

        public Integer getId() {
            return id;
        }

        public String getDescricao() {
            return descricao;
        }
    }
}
