package com.projeto.fatec.classes.parceiro.area;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "TB_areas_parceiros")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AreaParceiroEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "descricao", nullable = false, length = 55, unique = true)
    private String descricao;

    @Column(name = "ativo", nullable = false)
    @Builder.Default
    private Boolean ativo = true;
}
