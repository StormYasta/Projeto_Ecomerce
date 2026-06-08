package com.projeto.fatec.classes.usuario;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.*;

import java.io.Serializable;

@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class UsuarioId implements Serializable {

    @Column(name = "id")
    private Long id;

    @Column(name = "pessoa_id")
    private Long pessoaId;
}
