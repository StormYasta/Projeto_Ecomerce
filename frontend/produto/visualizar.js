const API_URL        = 'http://localhost:8080/produtos';

const viewContent = document.getElementById('view-content');
const viewOutput  = document.getElementById('view-output');

/* =========================
   CARREGAR PRODUTOS
========================= */
async function loadProdutos(apenasAtivos = false) {
    try {
        viewContent.innerHTML = '<p>Carregando produtos...</p>';

        const response = await fetch(API_URL);

        if (!response.ok) throw new Error('Erro ao buscar produtos');

        const produtos = await response.json();
        renderProdutos(produtos);

    } catch (error) {
        console.error(error);
        viewContent.innerHTML  = '<p class="error">Erro ao carregar dados.</p>';
        viewOutput.textContent = 'Falha na requisição à API.';
    }
}

/* =========================
   RENDERIZAR LISTA
========================= */
function renderProdutos(produtos) {
    viewContent.innerHTML = '';

    if (!produtos || produtos.length === 0) {
        viewContent.innerHTML  = '<p class="empty-state">Nenhum produto encontrado.</p>';
        viewOutput.textContent = 'Sem registros.';
        return;
    }

    produtos.forEach(p => viewContent.appendChild(renderProdutoCard(p)));

    viewOutput.textContent = `Total de produtos: ${produtos.length}`;
}

/* =========================
   CARD DE PRODUTO
========================= */
function renderProdutoCard(produto) {
    const card = document.createElement('div');
    card.className = 'record-card';

    const title = document.createElement('h3');
    title.textContent = `${produto.nome} (#${produto.idProduto})`;
    card.appendChild(title);

    const fields = {
        'Descrição':        produto.descricao,
        'Preço de Venda':   formatarMoeda(produto.precoVenda),
        'Custo':            formatarMoeda(produto.custo),
        'Estoque':          produto.estoque,
        'Fornecedor':       `${produto.fornecedorNome} (#${produto.fornecedorId})`,
        'URL da Imagem':    produto.imagemUrl,
        'Ativo':            produto.ativo ? 'Sim' : 'Não'
    };

    Object.entries(fields).forEach(([label, value]) => {
        const row = document.createElement('div');
        row.className = 'record-row';

        const labelEl = document.createElement('span');
        labelEl.className   = 'record-label';
        labelEl.textContent = `${label}:`;

        const valueEl = document.createElement('span');
        valueEl.className   = 'record-value';
        valueEl.textContent = formatValue(value);

        row.appendChild(labelEl);
        row.appendChild(valueEl);
        card.appendChild(row);
    });

    return card;
}

/* =========================
   HELPERS
========================= */
function formatValue(value) {
    if (value === null || value === undefined || value === '') return '-';
    if (Array.isArray(value)) return value.join(', ');
    return value;
}

function formatarMoeda(value) {
    if (value === null || value === undefined) return '-';
    return Number(value).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
}

function clearView() {
    viewContent.innerHTML  = '<p class="empty-state">Visualização limpa.</p>';
    viewOutput.textContent = '';
}

/* =========================
   EVENTOS
========================= */
document.getElementById('refresh-data').addEventListener('click', () => loadProdutos());
document.getElementById('clear-data') .addEventListener('click', clearView);

document.addEventListener('DOMContentLoaded', () => {
    loadProdutos()
});

