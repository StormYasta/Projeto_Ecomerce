package com.projeto.fatec.classes.colaborador;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ColaboradorService {

    private final ColaboradorRepository repository;

    @Transactional
    public void criarColaborador(ColaboradorDTO.Insert dto) {

        repository.insertColaborador(
                dto.nome(),
                dto.sobrenome(),
                dto.cpf(),
                dto.statusId(),
                dto.dataNascimento(),
                dto.email(),
                dto.telefone(),
                dto.cep(),
                dto.numero(),
                dto.logradouro(),
                dto.bairro(),
                dto.cidade(),
                dto.uf(),
                dto.complemento(),
                dto.funcao(),
                dto.salarioInicial(),
                dto.dataResgistro(),
                dto.numeroCTPS(),
                dto.numeroCNH(),
                dto.login(),
                dto.hashSenha());
    }

    @Transactional(readOnly = true)
    public List<ColaboradorViewProjection> listarColaboradores() {
        return repository.listarColaboradores();
    }

    @Transactional(readOnly = true)
    public ColaboradorViewProjection findColaborador(Long id) {
        return repository.ColaboradorById(id);
    }

    @Transactional
    public void atualizarColaborador(ColaboradorDTO.Update dto) {

        repository.updateColaborador(
                dto.pessoaId(),
                dto.nome(),
                dto.sobrenome(),
                dto.cpf(),
                dto.statusId(),
                dto.dataNascimento(), 
                dto.funcao(),
                dto.salarioAtual(),
                dto.numeroCNH(),
                dto.numeroCTPS(),
                dto.dataRegistro());
    }

    @Transactional
    public void inativarColaborador(Long pessoaId) {
        repository.inactivatePessoa(pessoaId);
    }
}
