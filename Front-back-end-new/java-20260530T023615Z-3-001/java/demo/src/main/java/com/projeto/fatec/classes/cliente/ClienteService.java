package com.projeto.fatec.classes.cliente;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ClienteService {

    private final ClienteRepository repository;

    @Transactional
    public void criarCliente(ClienteDTO.Insert dto) {

        repository.inserirCliente(
                dto.nome(),
                dto.sobrenome(),
                dto.cpf(),
                dto.statusId(),
                dto.dataNascimento(),
                dto.nomeSocial(),
                dto.sobrenomeSocial(),
                dto.email(),
                dto.telefone(),
                dto.cep(),
                dto.numero(),
                dto.logradouro(),
                dto.bairro(),
                dto.cidade(),
                dto.uf(),
                dto.complemento(),
                dto.login(),
                dto.hashSenha());
    }

    @Transactional(readOnly = true)
    public List<ClienteViewProjection> listarClientes() {
        return repository.listarClientes();
    }

    @Transactional(readOnly = true)
    public ClienteViewProjection findCliente(Long id) {
        return repository.clienteById(id);
    }

    @Transactional
    public void atualizarCliente(ClienteDTO.Update dto) {

        repository.updateCliente(
                dto.pessoaId(),
                dto.nome(),
                dto.sobrenome(),
                dto.cpf(),
                dto.statusId(),
                dto.dataNascimento(),
                dto.nomeSocial(),
                dto.sobrenomeSocial());
    }

    @Transactional
    public void inativarCliente(Long pessoaId) {
        repository.inactivatePessoa(pessoaId);
    }
}