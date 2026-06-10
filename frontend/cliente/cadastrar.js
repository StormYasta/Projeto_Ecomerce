const formCliente = document.getElementById('form-cliente');

formCliente.addEventListener('submit', async (e) => {
    e.preventDefault();
    const dto = {
        nome: document.getElementById('nome').value,
        sobrenome: document.getElementById('sobrenome').value,
        cpf: document.getElementById('cpf').value.replace(/\D/g, ''),
        statusId: parseInt(document.getElementById('statusId').value),
        dataNascimento: document.getElementById('dataNascimento').value,
        email: document.getElementById('email').value,
        telefone: document.getElementById('telefone').value.replace(/\D/g, ''),
        cep: document.getElementById('cep').value.replace(/\D/g, ''),
        numero: document.getElementById('numero').value,
        logradouro: document.getElementById('logradouro').value,
        bairro: document.getElementById('bairro').value,
        cidade: document.getElementById('cidade').value,
        uf: document.getElementById('uf').value,
        complemento: document.getElementById('complemento').value || null,
        login: document.getElementById('login').value,
        hashSenha: document.getElementById('senha').value
    };

    try {
        const response = await apiFetch(
            'http://localhost:8080/clientes',
            {
                method: 'POST',
                body: JSON.stringify(dto)
            }
        );

        const texto = await response.text();
        document.getElementById('output').textContent = texto;
        if (response.ok) {
            alert('Cliente cadastrado com sucesso!');
            formCliente.reset();
            document.getElementById('telefone').value = '+55';
        }

    } catch (error) {
        console.error(error);
        document.getElementById('output').textContent =
            'Erro ao conectar com a API';
    }
});

document.addEventListener('DOMContentLoaded', () => {

    inserirMascaraCpf(cpf);
    inserirMascaraCep(cep);
    inserirMascaraTelefone(telefone);
});

