const API_BASE = window.location.origin.includes('8080') ? '' : 'http://localhost:8080';
const API_URL = `${API_BASE}/pedidos`;
const viewContent = document.getElementById('view-content');
const viewOutput = document.getElementById('view-output');
const refreshButton = document.getElementById('refresh-data');
const clearButton = document.getElementById('clear-data');

refreshButton.addEventListener('click', () => loadPedidos());
clearButton.addEventListener('click', clearView);

window.addEventListener('load', loadPedidos);

async function loadPedidos() {
    try {
        viewContent.innerHTML = '<p>Carregando pedidos...</p>';

        const response = await fetch(API_URL);
        if (!response.ok) throw new Error('Erro ao buscar pedidos');

        const pedidos = await response.json();
        renderPedidos(pedidos);

    } catch (error) {
        console.error(error);
        viewContent.innerHTML = '<p class="error">Erro ao carregar dados.</p>';
        viewOutput.textContent = 'Falha na requisição à API.';
    }
}

function renderPedidos(pedidos) {
    viewContent.innerHTML = '';

    if (!pedidos || pedidos.length === 0) {
        viewContent.innerHTML = '<p class="empty-state">Nenhum pedido encontrado.</p>';
        viewOutput.textContent = 'Sem registros.';
        return;
    }

    pedidos.forEach(pedido => viewContent.appendChild(renderPedidoCard(pedido)));
    viewOutput.textContent = `Total de pedidos: ${pedidos.length}`;
}

function renderPedidoCard(pedido) {
    const card = document.createElement('div');
    card.className = 'record-card';

    const title = document.createElement('h3');
    title.textContent = `Pedido #${pedido.id}`;
    card.appendChild(title);

    const fields = {
        'Cliente ID': pedido.clienteId,
        'Produto ID': pedido.produtoId,
        'Status': pedido.statusId,
        'Data do Pedido': pedido.dataPedido
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

function formatValue(value) {
    if (value === null || value === undefined || value === '') return '-';
    if (Array.isArray(value)) return value.join(', ');
    return value;
}

function clearView() {
    viewContent.innerHTML = '<p class="empty-state">Visualização limpa.</p>';
    viewOutput.textContent = '';
}
