const API_URL = 'http://localhost:8080/fornecedores';

const formFornecedor = document.getElementById('form-fornecedor');

formFornecedor.addEventListener('submit', async (e) => {
    e.preventDefault();

    const dto = {
        nome:      document.getElementById('nome').value,
        cnpj:      document.getElementById('cnpj').value.replace(/\D/g, ''),
        email:     document.getElementById('email').value,
        telefone:  document.getElementById('telefone').value.replace(/\D/g, ''),
        descricao: document.getElementById('descricao').value || null
    };

    try {
        const response = await apiFetch(API_URL, {
            method: 'POST',
            body: JSON.stringify(dto)
        });

        const texto = await response.text();
        document.getElementById('output').textContent = texto;

        if (response.ok) {
            alert('Fornecedor cadastrado com sucesso!');
            formFornecedor.reset();
        }

    } catch (error) {
        console.error(error);
        document.getElementById('output').textContent = 'Erro ao conectar com a API';
    }
});

document.addEventListener('DOMContentLoaded', () => {
    inserirMascaraCnpj(cnpjw);
    inserirMascaraTelefone(telefone);
});
