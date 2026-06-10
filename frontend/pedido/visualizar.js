const API_URL = 'http://localhost:8080/pedidos';

const viewContent = document.getElementById('view-content');
const viewOutput  = document.getElementById('view-output');

/* =========================
   CARREGAR PEDIDOS
========================= */
async function loadPedidos() {
    try {
        viewContent.innerHTML = '<p>Carregando pedidos...</p>';

        const response = await apiFetch(API_URL);

        if (!response.ok) throw new Error('Erro ao buscar pedidos');

        const pedidos = await response.json();
        renderPedidos(pedidos);

    } catch (error) {
        console.error(error);
        viewContent.innerHTML  = '<p class="error">Erro ao carregar dados.</p>';
        viewOutput.textContent = 'Falha na requisição à API.';
    }
}

/* =========================
   RENDERIZAR LISTA
========================= */
function renderPedidos(pedidos) {
    viewContent.innerHTML = '';

    if (!pedidos || pedidos.length === 0) {
        viewContent.innerHTML  = '<p class="empty-state">Nenhum pedido encontrado.</p>';
        viewOutput.textContent = 'Sem registros.';
        return;
    }

    pedidos.forEach(p => viewContent.appendChild(renderPedidoCard(p)));

    viewOutput.textContent = `Total de pedidos: ${pedidos.length}`;
}

/* =========================
   CARD DE PEDIDO
========================= */
function renderPedidoCard(pedido) {
    const card = document.createElement('div');
    card.className = 'record-card';

    const title = document.createElement('h3');
    title.textContent = `Pedido #${pedido.pedidoId} — ${pedido.status}`;
    card.appendChild(title);

    const fields = {
        'Cliente':  pedido.clienteId,
        'Data':     formatarDataHora(pedido.data),
        'Status':   pedido.status
    };

    Object.entries(fields).forEach(([label, value]) => {
        const row = document.createElement('div');
        row.className = 'record-row';

        const labelEl = document.createElement('span');
        labelEl.className   = 'record-label';
        labelEl.textContent = `${label}:`;

        const valueEl = document.createElement('span');
        valueEl.className   = 'record-value';
        valueEl.textContent = value ?? '-';

        row.appendChild(labelEl);
        row.appendChild(valueEl);
        card.appendChild(row);
    });

    // área de itens — carregada sob demanda
    const itensToggle = document.createElement('button');
    itensToggle.type      = 'button';
    itensToggle.className = 'small-button';
    itensToggle.textContent = 'Ver Itens';
    itensToggle.style.marginTop = '0.5rem';

    const itensArea = document.createElement('div');
    itensArea.className = 'itens-area';
    itensArea.style.display = 'none';
    itensArea.style.marginTop = '0.5rem';

    let itensCarregados = false;

    itensToggle.addEventListener('click', async () => {
        if (itensArea.style.display === 'none') {
            itensArea.style.display = 'block';
            itensToggle.textContent = 'Ocultar Itens';

            if (!itensCarregados) {
                itensArea.innerHTML = '<p>Carregando itens...</p>';
                await carregarItensNoCard(pedido.pedidoId, itensArea);
                itensCarregados = true;
            }
        } else {
            itensArea.style.display = 'none';
            itensToggle.textContent = 'Ver Itens';
        }
    });

    card.appendChild(itensToggle);
    card.appendChild(itensArea);

    return card;
}

/* =========================
   CARREGAR ITENS NO CARD
========================= */
async function carregarItensNoCard(pedidoId, container) {
    try {
        const response = await apiFetch(`${API_URL}/${pedidoId}/itens`);

        if (!response.ok) throw new Error();

        const itens = await response.json();

        if (!itens || itens.length === 0) {
            container.innerHTML = '<p class="empty-state" style="font-size:.85rem">Nenhum item neste pedido.</p>';
            return;
        }

        container.innerHTML = '';

        // tabela simples de itens
        const table = document.createElement('table');
        table.style.cssText = 'width:100%;border-collapse:collapse;font-size:.85rem;margin-top:.25rem';

        const thead = document.createElement('thead');
        thead.innerHTML = `
            <tr>
                <th style="text-align:left;padding:4px 8px;border-bottom:1px solid #ccc">Produto</th>
                <th style="text-align:left;padding:4px 8px;border-bottom:1px solid #ccc">ID</th>
                <th style="text-align:left;padding:4px 8px;border-bottom:1px solid #ccc">Qtd</th>
                <th style="text-align:left;padding:4px 8px;border-bottom:1px solid #ccc">Valor Pago</th>
            </tr>`;
        table.appendChild(thead);

        const tbody = document.createElement('tbody');

        itens.forEach(item => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td style="padding:4px 8px">${item.nome}</td>
                <td style="padding:4px 8px">#${item.produtoId}</td>
                <td style="padding:4px 8px">${item.quantidade}</td>
                <td style="padding:4px 8px">${formatarMoeda(item.valorPago)}</td>`;
            tbody.appendChild(tr);
        });

        table.appendChild(tbody);
        container.appendChild(table);

    } catch {
        container.innerHTML = '<p class="error" style="font-size:.85rem">Erro ao carregar itens.</p>';
    }
}

/* =========================
   HELPERS
========================= */
function formatarDataHora(value) {
    if (!value) return '-';
    return new Date(value).toLocaleString('pt-BR');
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
document.getElementById('refresh-data').addEventListener('click', loadPedidos);
document.getElementById('clear-data')  .addEventListener('click', clearView);

window.addEventListener('load', loadPedidos);
