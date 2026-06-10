const API_URL       = 'http://localhost:8080/fornecedores';
const API_URL_ATIVOS = 'http://localhost:8080/fornecedores/ativos';

const viewContent  = document.getElementById('view-content');
const viewOutput   = document.getElementById('view-output');

/* =========================
   CARREGAR FORNECEDORES
========================= */
async function loadFornecedores(apenasAtivos = false) {
    try {
        viewContent.innerHTML = '<p>Carregando fornecedores...</p>';

        const url = apenasAtivos ? API_URL_ATIVOS : API_URL;
        const response = await apiFetch(url);

        if (!response.ok) {
            throw new Error('Erro ao buscar fornecedores');
        }

        const fornecedores = await response.json();
        renderFornecedores(fornecedores);

    } catch (error) {
        console.error(error);
        viewContent.innerHTML = '<p class="error">Erro ao carregar dados.</p>';
        viewOutput.textContent = 'Falha na requisição à API.';
    }
}

/* =========================
   RENDERIZAR LISTA
========================= */
function renderFornecedores(fornecedores) {
    viewContent.innerHTML = '';

    if (!fornecedores || fornecedores.length === 0) {
        viewContent.innerHTML = '<p class="empty-state">Nenhum fornecedor encontrado.</p>';
        viewOutput.textContent = 'Sem registros.';
        return;
    }

    fornecedores.forEach(f => {
        viewContent.appendChild(renderFornecedorCard(f));
    });

    viewOutput.textContent = `Total de fornecedores: ${fornecedores.length}`;
}

/* =========================
   CARD DE FORNECEDOR
========================= */
function renderFornecedorCard(fornecedor) {
    const card = document.createElement('div');
    card.className = 'record-card';

    const title = document.createElement('h3');
    title.textContent = `${fornecedor.nome} (#${fornecedor.idFornecedor})`;
    card.appendChild(title);

    const fields = {
        'CNPJ':      fornecedor.cNPJ ?? fornecedor.cnpj,
        'Email':     fornecedor.email,
        'Telefone':  fornecedor.telefone,
        'Descrição': fornecedor.descricao,
        'Ativo':     fornecedor.ativo ? 'Sim' : 'Não'
    };

    Object.entries(fields).forEach(([label, value]) => {
        const row = document.createElement('div');
        row.className = 'record-row';

        const labelEl = document.createElement('span');
        labelEl.className = 'record-label';
        labelEl.textContent = `${label}:`;

        const valueEl = document.createElement('span');
        valueEl.className = 'record-value';
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

function clearView() {
    viewContent.innerHTML = '<p class="empty-state">Visualização limpa.</p>';
    viewOutput.textContent = '';
}

/* =========================
   EVENTOS
========================= */
document.getElementById('btn-todos')   .addEventListener('click', () => loadFornecedores(false));
document.getElementById('btn-ativos')  .addEventListener('click', () => loadFornecedores(true));
document.getElementById('refresh-data').addEventListener('click', () => loadFornecedores(false));
document.getElementById('clear-data') .addEventListener('click', clearView);

window.addEventListener('load', () => loadFornecedores(false));
