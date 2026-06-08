package com.projeto.fatec.utils;

import java.time.LocalDate;
import java.time.Period;

public class NascimentoValidator {

    private static final int MAX_AGE = 120;
    private static final int MIN_AGE = 18;

    /**
     * Valida se a data de nascimento é válida:
     * - não pode ser futura
     * - não pode ser mais antiga que 120 anos
     */
    public static boolean isValid(LocalDate dataNascimento) {

        if (dataNascimento == null) {
            return false;
        }

        LocalDate today = LocalDate.now();

        if (dataNascimento.isAfter(today)) {
            return false;
        }

        if (dataNascimento.isBefore(today.minusYears(MAX_AGE))) {
            return false;
        }

        return true;
    }

    /**
     * Verifica se é maior de idade (18 anos)
     */
    public static boolean isAdult(LocalDate dataNascimento) {

        if (dataNascimento == null) {
            return false;
        }

        LocalDate today = LocalDate.now();
        Period age = Period.between(dataNascimento, today);

        return age.getYears() >= MIN_AGE;
    }

    /**
     * Retorna idade exata
     */
    public static int calculateAge(LocalDate dataNascimento) {

        if (dataNascimento == null) {
            return -1;
        }

        return Period.between(dataNascimento, LocalDate.now()).getYears();
    }
}