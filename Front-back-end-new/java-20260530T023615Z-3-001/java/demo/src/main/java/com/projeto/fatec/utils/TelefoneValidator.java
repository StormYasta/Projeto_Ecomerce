package com.projeto.fatec.utils;

import java.util.regex.Pattern;

/**
 * Utilitário para validação de números de telefone.
 * Suporta formatos brasileiros e internacionais (E.164).
 */
public class TelefoneValidator {

    // Formatos brasileiros aceitos:
    private static final String BR_REGEX =
        "^(\\+?55\\s?)?" +                    // DDI opcional
        "(\\(?[1-9]{2}\\)?)\\s?" +            // DDD obrigatório
        "(9\\d{4}|\\d{4})" +                  // 9 + 4 dígitos (celular) ou 4 dígitos (fixo)
        "[\\s\\-]?" +
        "\\d{4}$";                             // últimos 4 dígitos

    // Formato internacional E.164: +<DDI><número> — até 15 dígitos
    private static final String INTL_REGEX =
        "^\\+[1-9]\\d{6,14}$";

    private static final Pattern BR_PATTERN   = Pattern.compile(BR_REGEX);
    private static final Pattern INTL_PATTERN = Pattern.compile(INTL_REGEX);

    public enum Formato { BRASILEIRO, INTERNACIONAL, INVALIDO }

    /**
     * Verifica se o telefone é válido (BR ou internacional).
     */
    public static boolean isValid(String phone) {
        return detectarFormato(phone) != Formato.INVALIDO;
    }

    /**
     * Detecta o formato do número.
     */
    public static Formato detectarFormato(String phone) {
        if (phone == null || phone.isBlank()) return Formato.INVALIDO;

        String limpo = phone.trim();

        if (BR_PATTERN.matcher(limpo).matches())   return Formato.BRASILEIRO;
        if (INTL_PATTERN.matcher(limpo).matches()) return Formato.INTERNACIONAL;

        return Formato.INVALIDO;
    }

    /**
     * Normaliza para somente dígitos (+ preservado se internacional).
     */
    public static String normalizar(String phone) {
        validate(phone);
        String limpo = phone.trim().replaceAll("[\\s()\\-]", "");
        return limpo;
    }

    /**
     * Verifica se é celular brasileiro (começa com 9 após o DDD).
     */
    public static boolean isCelularBrasileiro(String phone) {
        if (detectarFormato(phone) != Formato.BRASILEIRO) return false;
        String digits = phone.replaceAll("[^\\d]", "");
        // Remove DDI 55 se presente
        if (digits.startsWith("55") && digits.length() > 11) {
            digits = digits.substring(2);
        }
        // Após DDD (2 dígitos), verifica se começa com 9
        return digits.length() >= 11 && digits.charAt(2) == '9';
    }

    /**
     * Lança exceção se inválido.
     */
    public static void validate(String phone) {
        if (!isValid(phone)) {
            throw new IllegalArgumentException(
                "Telefone inválido: \"" + phone + "\""
            );
        }
    }
}