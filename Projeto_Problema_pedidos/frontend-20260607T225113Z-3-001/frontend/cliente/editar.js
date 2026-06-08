const API_URL = 'http://localhost:8080/clientes';

const output = document.getElementById('output');

/* =========================
   BUSCAR CLIENTE POR ID
========================= */
async function buscarClientePorId(id) {
    if (!id) {
        alert('Informe um ID válido');
        return;
    }

    try {
        const response = await fetch(`${API_URL}/${id}`);

        if (!response.ok) {
            throw new Error('Cliente não encontrado');
        }

        const cliente = await response.json();

        preencherFormularioCliente(cliente);

        output.textContent = JSON.stringify({
            mensagem: 'Cliente carregado com sucesso',
            cliente
        }, null, 2);

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao buscar cliente';
    }
}

/* =========================
   PREENCHER FORMULÁRIO
========================= */
function preencherFormularioCliente(cliente) {

    setValue('pessoaId', cliente.idCliente ?? cliente.pessoaId);
    setValue('nome', cliente.nome);
    setValue('sobrenome', cliente.sobrenome);
    setValue('cpf', formatarCpf(cliente.cpf));
    setValue('statusDescricao', cliente.statusId);
    setValue('dataNascimento', formatarData(cliente.dataNascimento));

    // trava ID
    const idField = document.querySelector('[name="pessoaId"]');
    if (idField) idField.readOnly = true;
}

/* =========================
   ATUALIZAR CLIENTE (PUT)
========================= */
async function atualizarCliente(event) {
    event.preventDefault();

    const form = event.target;
    const formData = new FormData(form);

    const data = {};

    for (const [key, value] of formData.entries()) {
        data[key] = value;
    }

    const id = data.pessoaId;

    if (!id) {
        alert('ID do cliente é obrigatório');
        return;
    }

    try {
        const response = await fetch(`${API_URL}/${id}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });

        const text = await response.text();

        output.textContent = JSON.stringify({
            status: response.status,
            resposta: text,
            enviado: data
        }, null, 2);

        if (response.ok) {
            alert('Cliente atualizado com sucesso!');
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao atualizar cliente';
    }
}

/* =========================
   HELPERS
========================= */
function setValue(name, value) {
    const field = document.querySelector(`[name="${name}"]`);
    if (!field) return;
    field.value = value ?? '';
}

function formatDate(date) {
    if (!date) return '';
    return date.split('T')[0];
}

/* =========================
   EVENTOS
========================= */

// botão de busca
document.getElementById('btn-search').addEventListener('click', () => {
    const id = document.getElementById('search-id').value;
    buscarClientePorId(id);
});

// submit do form
document.getElementById('form-cliente')
    .addEventListener('submit', atualizarCliente);

async function deletarCliente() {

    const id = document.querySelector('[name="pessoaId"]').value;

    if (!id) {
        alert('Carregue um cliente antes de inativar');
        return;
    }

    const confirmar = confirm('Tem certeza que deseja inativar este cliente?');

    if (!confirmar) return;

    try {
        const response = await fetch(`${API_URL}/${id}`, {
            method: 'DELETE'
        });

        const text = await response.text();

        output.textContent = JSON.stringify({
            status: response.status,
            resposta: text
        }, null, 2);

        if (response.ok) {
            alert('Cliente inativado com sucesso!');
            limparCampos();
            document.getElementById('form-cliente').reset();
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao inativar cliente';
    }
}
document.getElementById('btn-delete')
    .addEventListener('click', deletarCliente);

function limparCampos() {
    document.getElementById('form-cliente').reset();

    const idField = document.querySelector('[name="pessoaId"]');
    if (idField) {
        idField.readOnly = false;
        idField.value = '';
    }

    const searchField = document.getElementById('search-id');
    if (searchField) {
        searchField.value = '';
    }

    output.textContent = 'Aguardando operação...';
}

document.addEventListener('DOMContentLoaded', () => {

    inserirMascaraCpf(cpf);
    inserirMascaraData(dataNascimento);
});