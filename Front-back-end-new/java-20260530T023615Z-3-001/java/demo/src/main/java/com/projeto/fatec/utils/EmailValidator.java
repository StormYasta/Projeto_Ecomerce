package com.projeto.fatec.utils;

import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class EmailValidator {

    private static final int MAX_EMAIL_LENGTH = 254;
    private static final int MAX_LOCAL_LENGTH = 64;

    private static final String EMAIL_REGEX =
        "^[a-zA-Z0-9._%+\\-]+" +
        "@" +
        "[a-zA-Z0-9.\\-]+" +
        "\\.[a-zA-Z]{2,}$";

    private static final Pattern EMAIL_PATTERN =
        Pattern.compile(EMAIL_REGEX);

    /**
     * Verifica se o e-mail é válido.
     *
     * @param email endereço de e-mail a validar
     * @return true se válido, false caso contrário
     */
    public static boolean isValid(String email) {
        if (email == null || email.isBlank()) {
            return false;
        }

        String trimmed = email.trim();

        if (trimmed.length() > MAX_EMAIL_LENGTH) {
            return false;
        }

        int atIndex = trimmed.indexOf('@');
        if (atIndex < 0) {
            return false;
        }

        String localPart = trimmed.substring(0, atIndex);
        if (localPart.length() > MAX_LOCAL_LENGTH) {
            return false;
        }

        Matcher matcher = EMAIL_PATTERN.matcher(trimmed);
        return matcher.matches();
    }

    /**
     * Valida e lança exceção com mensagem descritiva se inválido.
     *
     * @param email endereço de e-mail a validar
     * @throws IllegalArgumentException se o e-mail for inválido
     */
    public static void validate(String email) {
        if (!isValid(email)) {
            throw new IllegalArgumentException(
                "E-mail inválido: \"" + email + "\""
            );
        }
    }

    /**
     * Retorna o domínio de um e-mail válido.
     *
     * @param email endereço de e-mail
     * @return domínio (ex: "gmail.com")
     * @throws IllegalArgumentException se o e-mail for inválido
     */
    public static String extractDomain(String email) {
        validate(email);
        return email.trim().substring(email.indexOf('@') + 1);
    }
}