const API_URL = 'http://localhost:8080/fornecedores';

const output = document.getElementById('output');

/* =========================
   BUSCAR FORNECEDOR POR ID
========================= */
async function buscarFornecedorPorId(id) {
    if (!id) {
        alert('Informe um ID válido');
        return;
    }

    try {
        const response = await apiFetch(`${API_URL}/${id}`);

        if (!response.ok) {
            throw new Error('Fornecedor não encontrado');
        }

        const fornecedor = await response.json();

        preencherFormulario(fornecedor);

        output.textContent = JSON.stringify({
            mensagem: 'Fornecedor carregado com sucesso',
            fornecedor
        }, null, 2);

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao buscar fornecedor';
    }
}

/* =========================
   PREENCHER FORMULÁRIO
========================= */
function preencherFormulario(fornecedor) {
    setValue('id',        fornecedor.idFornecedor ?? fornecedor.id);
    setValue('nome',      fornecedor.nome);
    setValue('cnpj',      fornecedor.cNPJ ?? fornecedor.cnpj);
    setValue('email',     fornecedor.email);
    setValue('telefone',  fornecedor.telefone);
    setValue('descricao', fornecedor.descricao);

    const idField = document.getElementById('id');
    if (idField) idField.readOnly = true;
}

/* =========================
   ATUALIZAR FORNECEDOR (PUT)
========================= */
async function atualizarFornecedor(event) {
    event.preventDefault();

    const form = event.target;
    const formData = new FormData(form);
    const data = {};

    for (const [key, value] of formData.entries()) {
        data[key] = value;
    }

    // limpa máscaras antes de enviar
    if (data.cnpj)    data.cnpj    = data.cnpj.replace(/\D/g, '');
    if (data.telefone) data.telefone = data.telefone.replace(/\D/g, '');
    if (!data.descricao) data.descricao = null;

    const id = data.id;

    if (!id) {
        alert('ID do fornecedor é obrigatório');
        return;
    }

    try {
        const response = await apiFetch(`${API_URL}/${id}`, {
            method: 'PUT',
            body: JSON.stringify(data)
        });

        const text = await response.text();

        output.textContent = JSON.stringify({
            status: response.status,
            resposta: text,
            enviado: data
        }, null, 2);

        if (response.ok) {
            alert('Fornecedor atualizado com sucesso!');
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao atualizar fornecedor';
    }
}
/* =========================
   ATIVAR FORNECEDOR
========================= */
async function ativarFornecedor() {
    const id = document.getElementById('id').value;

    if (!id) {
        alert('Carregue um fornecedor antes de ativar');
        return;
    }
    try {
        const response = await apiFetch(`${API_URL}/ativar/${id}`, {
            method: 'PUT'
        });

        const text = await response.text();

        output.textContent = JSON.stringify({
            status: response.status,
            resposta: text
        }, null, 2);

        if (response.ok) {
            alert('Fornecedor ativado com sucesso!');
            limparCampos();
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao ativar fornecedor';
    }
}
/* =========================
   INATIVAR FORNECEDOR (DELETE)
========================= */
async function inativarFornecedor() {
    const id = document.getElementById('id').value;

    if (!id) {
        alert('Carregue um fornecedor antes de inativar');
        return;
    }

    const confirmar = confirm('Tem certeza que deseja inativar este fornecedor?');
    if (!confirmar) return;

    try {
        const response = await apiFetch(`${API_URL}/${id}`, {
            method: 'DELETE'
        });

        const text = await response.text();

        output.textContent = JSON.stringify({
            status: response.status,
            resposta: text
        }, null, 2);

        if (response.ok) {
            alert('Fornecedor inativado com sucesso!');
            limparCampos();
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao inativar fornecedor';
    }
}

/* =========================
   HELPERS
========================= */
function setValue(id, value) {
    const field = document.getElementById(id);
    if (!field) return;
    field.value = value ?? '';
}

function limparCampos() {
    document.getElementById('form-fornecedor').reset();

    const idField = document.getElementById('id');
    if (idField) {
        idField.readOnly = false;
        idField.value = '';
    }

    const searchField = document.getElementById('search-id');
    if (searchField) searchField.value = '';

    output.textContent = 'Aguardando operação...';
}

/* =========================
   EVENTOS
========================= */
document.getElementById('btn-search').addEventListener('click', () => {
    const id = document.getElementById('search-id').value;
    buscarFornecedorPorId(id);
});

document.getElementById('form-fornecedor').addEventListener('submit', atualizarFornecedor);

document.getElementById('btn-delete').addEventListener('click', inativarFornecedor);

document.getElementById('btn-ativar').addEventListener('click', ativarFornecedor);

document.addEventListener('DOMContentLoaded', () => {
    inserirMascaraCnpj(document.getElementById('cnpj'));
    inserirMascaraTelefone(document.getElementById('telefone'));
});
