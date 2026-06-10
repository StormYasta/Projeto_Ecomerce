package com.projeto.fatec.login;

import com.projeto.fatec.classes.usuario.UsuarioEntity;
import com.projeto.fatec.classes.usuario.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class LoginService {

    private final UsuarioRepository repository;
    private final JwtUtil jwtUtil;

    @Transactional(readOnly = true)
    public LoginDTO.Response validarLogin(LoginDTO.Request dto) {

        UsuarioEntity usuario = repository
                .findByUsuarioLoginAndAtivoTrueAndDeletedAtIsNull(dto.login())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado ou inativo"));

        if (!usuario.getSenhaHash().equals(dto.senha())) {
            throw new RuntimeException("Credenciais inválidas");
        }

        TipoUsuario tipo = resolverTipo(usuario.getRole().getDescricao());

        Long pessoaId = usuario.getPessoa().getId();
        String nome = usuario.getPessoa().getNome();

        String token = jwtUtil.gerarToken(pessoaId, usuario.getUsuarioLogin(), tipo);

        return new LoginDTO.Response(token, tipo, pessoaId, nome);
    }

    private TipoUsuario resolverTipo(String roleDescricao) {
        return switch (roleDescricao.toUpperCase()) {
            case "ADMIN", "COLABORADOR" -> TipoUsuario.ADMIN;
            case "CLIENTE"              -> TipoUsuario.CLIENTE;
            default -> throw new RuntimeException("Role desconhecida: " + roleDescricao);
        };
    }
}