package com.projeto.fatec;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.sql.Connection;

@Component
public class TestConnection implements CommandLineRunner {

    private final DataSource dataSource;

    public TestConnection(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    @SuppressWarnings("CallToPrintStackTrace")
    public void run(String... args) {
        try (Connection conn = dataSource.getConnection()) {

            if (conn != null && !conn.isClosed()) {
                System.out.println("Conexão com o banco realizada com sucesso!");
                System.out.println("Banco: " + conn.getCatalog());
            } else {
                System.out.println("Falha ao conectar com o banco.");
            }

        } catch (Exception e) {
            System.out.println("Erro ao tentar conectar:");
            e.printStackTrace();
        }
    }
}