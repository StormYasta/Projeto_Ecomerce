const API_URL = 'http://localhost:8080/pedidos';

const output       = document.getElementById('output');
const itensContent = document.getElementById('itens-content');
const labelPedidoId = document.getElementById('label-pedido-id');

/* =========================
   BUSCAR ITENS DO PEDIDO
========================= */
async function carregarItensPedido(pedidoId) {
    if (!pedidoId) {
        alert('Informe um ID de pedido válido');
        return;
    }

    try {
        itensContent.innerHTML = '<p>Carregando itens...</p>';

        const response = await apiFetch(`${API_URL}/${pedidoId}/itens`);

        if (!response.ok) throw new Error('Pedido não encontrado');

        const itens = await response.json();

        // propaga o pedidoId para todos os formulários da página
        propagarPedidoId(pedidoId);
        renderItens(itens, pedidoId);

        output.textContent = `Pedido #${pedidoId} carregado. Total de itens: ${itens.length}`;

    } catch (error) {
        console.error(error);
        itensContent.innerHTML = '<p class="error">Erro ao carregar itens do pedido.</p>';
        output.textContent = 'Falha na requisição à API.';
    }
}

function propagarPedidoId(pedidoId) {
    document.getElementById('add-pedido-id').value    = pedidoId;
    document.getElementById('edit-pedido-id').value   = pedidoId;
    document.getElementById('remove-pedido-id').value = pedidoId;
    labelPedidoId.textContent = `— Pedido #${pedidoId}`;
}

/* =========================
   RENDERIZAR ITENS
========================= */
function renderItens(itens, pedidoId) {
    itensContent.innerHTML = '';

    if (!itens || itens.length === 0) {
        itensContent.innerHTML = '<p class="empty-state">Nenhum produto adicionado a este pedido.</p>';
        return;
    }

    itens.forEach(item => {
        const card = document.createElement('div');
        card.className = 'record-card';

        const title = document.createElement('h3');
        title.textContent = `${item.nome} (Produto #${item.produtoId})`;
        card.appendChild(title);

        const fields = {
            'Quantidade':   item.quantidade,
            'Valor Pago':   formatarMoeda(item.valorPago)
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

        // atalho: preenche os campos de edição e remoção ao clicar no card
        card.style.cursor = 'pointer';
        card.title = 'Clique para preencher os campos de edição/remoção';
        card.addEventListener('click', () => {
            document.getElementById('edit-produto-id').value   = item.produtoId;
            document.getElementById('remove-produto-id').value = item.produtoId;
            output.textContent = `Produto #${item.produtoId} selecionado.`;
        });

        itensContent.appendChild(card);
    });
}

/* =========================
   ADICIONAR ITEM
========================= */
document.getElementById('form-add-item').addEventListener('submit', async (e) => {
    e.preventDefault();

    const pedidoId = document.getElementById('add-pedido-id').value;

    if (!pedidoId) {
        alert('Carregue um pedido antes de adicionar itens');
        return;
    }

    const dto = {
        produtoId:  parseInt(document.getElementById('add-produto-id').value),
        quantidade: parseInt(document.getElementById('add-quantidade').value),
        valorPago:  parseFloat(document.getElementById('add-valor-pago').value)
    };

    try {
        const response = await apiFetch(`${API_URL}/${pedidoId}/itens`, {
            method:  'POST',
            body:    JSON.stringify(dto)
        });

        const texto = await response.text();

        output.textContent = JSON.stringify({
            status:   response.status,
            resposta: texto,
            enviado:  dto
        }, null, 2);

        if (response.ok) {
            alert('Produto adicionado ao pedido!');
            document.getElementById('form-add-item').reset();
            document.getElementById('add-pedido-id').value = pedidoId;
            carregarItensPedido(pedidoId);
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao adicionar item';
    }
});

/* =========================
   ALTERAR QUANTIDADE
========================= */
document.getElementById('form-edit-item').addEventListener('submit', async (e) => {
    e.preventDefault();

    const pedidoId  = document.getElementById('edit-pedido-id').value;
    const produtoId = document.getElementById('edit-produto-id').value;

    if (!pedidoId || !produtoId) {
        alert('Carregue um pedido e informe o ID do produto');
        return;
    }

    const dto = {
        quantidade: parseInt(document.getElementById('edit-quantidade').value)
    };

    try {
        const response = await apiFetch(`${API_URL}/${pedidoId}/itens/${produtoId}`, {
            method:  'PUT',
            body:    JSON.stringify(dto)
        });

        const texto = await response.text();

        output.textContent = JSON.stringify({
            status:   response.status,
            resposta: texto,
            enviado:  dto
        }, null, 2);

        if (response.ok) {
            alert('Quantidade atualizada com sucesso!');
            document.getElementById('form-edit-item').reset();
            document.getElementById('edit-pedido-id').value = pedidoId;
            carregarItensPedido(pedidoId);
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao atualizar quantidade';
    }
});

/* =========================
   REMOVER ITEM
========================= */
document.getElementById('form-remove-item').addEventListener('submit', async (e) => {
    e.preventDefault();

    const pedidoId  = document.getElementById('remove-pedido-id').value;
    const produtoId = document.getElementById('remove-produto-id').value;

    if (!pedidoId || !produtoId) {
        alert('Carregue um pedido e informe o ID do produto');
        return;
    }

    const confirmar = confirm(`Remover produto #${produtoId} do pedido #${pedidoId}?`);
    if (!confirmar) return;

    try {
        const response = await apiFetch(`${API_URL}/${pedidoId}/itens/${produtoId}`, {
            method: 'DELETE'
        });

        const texto = await response.text();

        output.textContent = JSON.stringify({
            status:   response.status,
            resposta: texto
        }, null, 2);

        if (response.ok) {
            alert('Produto removido do pedido!');
            document.getElementById('form-remove-item').reset();
            document.getElementById('remove-pedido-id').value = pedidoId;
            carregarItensPedido(pedidoId);
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao remover item';
    }
});

/* =========================
   HELPERS
========================= */
function formatarMoeda(value) {
    if (value === null || value === undefined) return '-';
    return Number(value).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
}

/* =========================
   EVENTOS
========================= */
document.getElementById('btn-buscar-pedido').addEventListener('click', () => {
    const id = document.getElementById('search-pedido-id').value;
    carregarItensPedido(id);
});
