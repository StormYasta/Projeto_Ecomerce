const API_URL          = 'http://localhost:8080/produtos';
const API_FORNECEDORES = 'http://localhost:8080/fornecedores/ativos';

const output = document.getElementById('output');

/* =========================
   POPULAR SELECT DE FORNECEDORES
========================= */
async function carregarFornecedores(fornecedorAtualId = null) {
    const select = document.getElementById('fornecedorId');

    try {
        const response = await fetch(API_FORNECEDORES);
        if (!response.ok) throw new Error('Erro ao buscar fornecedores');

        const fornecedores = await response.json();

        select.innerHTML = '<option value="" disabled>Selecione um fornecedor</option>';

        fornecedores.forEach(f => {
            const option = document.createElement('option');
            option.value       = f.idFornecedor;
            option.textContent = f.nome;
            if (fornecedorAtualId && f.idFornecedor == fornecedorAtualId) {
                option.selected = true;
            }
            select.appendChild(option);
        });

    } catch (error) {
        console.error(error);
        select.innerHTML = '<option value="" disabled>Erro ao carregar fornecedores</option>';
    }
}

/* =========================
   BUSCAR PRODUTO POR ID
========================= */
async function buscarProdutoPorId(id) {
    if (!id) {
        alert('Informe um ID válido');
        return;
    }

    try {
        const response = await fetch(`${API_URL}/${id}`);
        console.log(response)
        if (!response.ok) throw new Error('Produto não encontrado');

        const produto = await response.json();

        await carregarFornecedores(produto.fornecedorId);
        preencherFormulario(produto);

        output.textContent = JSON.stringify({
            mensagem: 'Produto carregado com sucesso',
            produto
        }, null, 2);

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao buscar produto';
    }
}

/* =========================
   PREENCHER FORMULÁRIO
========================= */
function preencherFormulario(produto) {
    setValue('id',          produto.idProduto ?? produto.id);
    setValue('nome',        produto.nome);
    setValue('descricao',   produto.descricao);
    setValue('precoVenda',  produto.precoVenda);
    setValue('custo',       produto.custo);
    setValue('estoque',     produto.estoque);
    setValue('imagemUrl',   produto.imagemUrl);

    const idField = document.getElementById('id');
    if (idField) idField.readOnly = true;
}

/* =========================
   ATUALIZAR PRODUTO (PUT)
========================= */
async function atualizarProduto(event) {
    event.preventDefault();

    const form     = event.target;
    const formData = new FormData(form);
    const data     = {};

    for (const [key, value] of formData.entries()) {
        data[key] = value;
    }

    const id = data.id;

    if (!id) {
        alert('ID do produto é obrigatório');
        return;
    }

    // conversões de tipo
    data.precoVenda   = parseFloat(data.precoVenda);
    data.custo        = parseFloat(data.custo);
    data.estoque      = parseInt(data.estoque);
    data.fornecedorId = parseInt(data.fornecedorId);
    if (!data.imagemUrl) data.imagemUrl = null;

    try {
        const response = await fetch(`${API_URL}/${id}`, {
            method:  'PUT',
            headers: { 'Content-Type': 'application/json' },
            body:    JSON.stringify(data)
        });

        const text = await response.text();

        output.textContent = JSON.stringify({
            status:   response.status,
            resposta: text,
            enviado:  data
        }, null, 2);

        if (response.ok) {
            alert('Produto atualizado com sucesso!');
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao atualizar produto';
    }
}

/* =========================
   INATIVAR PRODUTO (DELETE)
========================= */
async function inativarProduto() {
    const id = document.getElementById('id').value;

    if (!id) {
        alert('Carregue um produto antes de inativar');
        return;
    }

    const confirmar = confirm('Tem certeza que deseja inativar este produto?');
    if (!confirmar) return;

    try {
        const response = await fetch(`${API_URL}/${id}`, {
            method: 'DELETE'
        });

        const text = await response.text();

        output.textContent = JSON.stringify({
            status:   response.status,
            resposta: text
        }, null, 2);

        if (response.ok) {
            alert('Produto inativado com sucesso!');
            limparCampos();
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao inativar produto';
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
    document.getElementById('form-produto').reset();

    const idField = document.getElementById('id');
    if (idField) {
        idField.readOnly = false;
        idField.value    = '';
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
    buscarProdutoPorId(id);
});

document.getElementById('form-produto').addEventListener('submit', atualizarProduto);

document.getElementById('btn-delete').addEventListener('click', inativarProduto);

document.addEventListener('DOMContentLoaded', () => carregarFornecedores());
