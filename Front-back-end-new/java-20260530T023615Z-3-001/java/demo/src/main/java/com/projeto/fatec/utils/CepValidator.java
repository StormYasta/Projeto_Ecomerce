package com.projeto.fatec.utils;

import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.Map;
import java.util.regex.Pattern;

@Component
public class CepValidator {

    private static final Pattern CEP_PATTERN = Pattern.compile("\\d{8}");

    private final WebClient viaCepClient;
    private final WebClient openCepClient;

    public CepValidator(WebClient.Builder builder) {

        this.viaCepClient = builder
                .baseUrl("https://viacep.com.br/ws")
                .build();

        this.openCepClient = builder
                .baseUrl("https://opencep.com/v1")
                .build();
    }

    public boolean isValid(String cep) {

        if (cep == null) {
            return false;
        }

        cep = cep.replaceAll("\\D", "");

        if (!CEP_PATTERN.matcher(cep).matches()) {
            return false;
        }

        // 1º tenta ViaCEP
        if (existsViaCep(cep)) {
            return true;
        }

        // 2º fallback OpenCEP
        return existsOpenCep(cep);
    }

    // ---------------- VIA CEP ----------------

    private boolean existsViaCep(String cep) {
        try {
            Map<?, ?> response = viaCepClient
                    .get()
                    .uri("/{cep}/json/", cep)
                    .retrieve()
                    .bodyToMono(Map.class)
                    .block();

            return response != null && !response.containsKey("erro");

        } catch (Exception e) {
            return false;
        }
    }

    // ---------------- OPEN CEP ----------------

    private boolean existsOpenCep(String cep) {
        try {
            Map<?, ?> response = openCepClient
                    .get()
                    .uri("/{cep}.json", cep)
                    .retrieve()
                    .bodyToMono(Map.class)
                    .block();

            return response != null && !response.isEmpty();

        } catch (Exception e) {
            return false;
        }
    }
}