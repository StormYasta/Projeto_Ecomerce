package com.projeto.fatec.service.cliente;

import java.util.List;
import com.projeto.fatec.entity.cliente.ClienteEntity;
import com.projeto.fatec.repository.cliente.ClienteRepository;

import org.springframework.http.HttpStatus;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ClienteService {

    private final ClienteRepository clienteRepository;

    @Transactional
    public ClienteEntity newCliente(@NonNull ClienteEntity cliente) {
        return clienteRepository.save(cliente);
    }

    @Transactional
    public List<ClienteEntity> listCliente() {
        return clienteRepository.findAll();
    }

    @Transactional
    public ClienteEntity findCliente(@NonNull Long id) {
        return clienteRepository.findById(id)
                .orElseThrow(() ->  new ResponseStatusException(HttpStatus.NOT_FOUND, "Cliente não encontrado"));
    }

    @SuppressWarnings("null")
    @Transactional
    public void deletCliente(@NonNull Long id) {
        ClienteEntity cliente = clienteRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Cliente não encontrado"));

        clienteRepository.delete(cliente);
    }
}
