const API_URL = 'http://localhost:8080/pedidos';

const output     = document.getElementById('output');
const pedidoInfo = document.getElementById('pedido-info');

/* =========================
   BUSCAR PEDIDO POR ID
========================= */
async function buscarPedido(id) {
    if (!id) {
        alert('Informe um ID válido');
        return;
    }

    try {
        const response = await apiFetch(`${API_URL}/${id}`);

        if (!response.ok) throw new Error('Pedido não encontrado');

        const pedido = await response.json();

        preencherInfo(pedido);

        output.textContent = JSON.stringify({
            mensagem: 'Pedido carregado com sucesso',
            pedido
        }, null, 2);

    } catch (error) {
        console.error(error);
        pedidoInfo.innerHTML   = '<p class="error">Pedido não encontrado.</p>';
        output.textContent = 'Erro ao buscar pedido.';
    }
}

/* =========================
   PREENCHER DADOS DO PEDIDO
========================= */
function preencherInfo(pedido) {
    const id = pedido.pedidoId ?? pedido.id;

    // propaga o id para o campo oculto do form
    document.getElementById('pedido-id').value = id;

    const fields = {
        'ID':       id,
        'Cliente':  pedido.clienteId,
        'Data':     formatarDataHora(pedido.data),
        'Status':   pedido.status
    };

    pedidoInfo.innerHTML = '';

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
        pedidoInfo.appendChild(row);
    });

    // pré-seleciona o status atual no select, se possível
    const statusMap = {
        'PENDENTE':          1,
        'EM PROCESSAMENTO':  2,
        'ENVIADO':           3,
        'ENTREGUE':          4
    };

    const select = document.getElementById('statusId');
    const statusAtualId = statusMap[pedido.status?.toUpperCase()];
    if (statusAtualId) select.value = statusAtualId;
}

/* =========================
   ATUALIZAR STATUS
========================= */
document.getElementById('form-status').addEventListener('submit', async (e) => {
    e.preventDefault();

    const pedidoId = document.getElementById('pedido-id').value;

    if (!pedidoId) {
        alert('Carregue um pedido antes de alterar o status');
        return;
    }

    const dto = {
        statusId: parseInt(document.getElementById('statusId').value)
    };

    try {
        const response = await apiFetch(`${API_URL}/${pedidoId}/status`, {
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
            alert('Status atualizado com sucesso!');
            buscarPedido(pedidoId);
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao atualizar status';
    }
});

/* =========================
   CANCELAR PEDIDO
========================= */
async function cancelarPedido() {
    const pedidoId = document.getElementById('pedido-id').value;

    if (!pedidoId) {
        alert('Carregue um pedido antes de cancelar');
        return;
    }

    const confirmar = confirm(`Tem certeza que deseja CANCELAR o pedido #${pedidoId}? Esta ação não pode ser desfeita.`);
    if (!confirmar) return;

    try {
        const response = await apiFetch(`${API_URL}/${pedidoId}`, {
            method: 'DELETE'
        });

        const texto = await response.text();

        output.textContent = JSON.stringify({
            status:   response.status,
            resposta: texto
        }, null, 2);

        if (response.ok) {
            alert('Pedido cancelado com sucesso!');
            limparTela();
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao cancelar pedido';
    }
}

/* =========================
   HELPERS
========================= */
function formatarDataHora(value) {
    if (!value) return '-';
    return new Date(value).toLocaleString('pt-BR');
}

function limparTela() {
    document.getElementById('search-id').value  = '';
    document.getElementById('pedido-id').value  = '';
    pedidoInfo.innerHTML = '<p class="empty-state">Nenhum pedido carregado.</p>';
    output.textContent   = 'Aguardando ação...';
}

/* =========================
   EVENTOS
========================= */
document.getElementById('btn-search').addEventListener('click', () => {
    const id = document.getElementById('search-id').value;
    buscarPedido(id);
});

document.getElementById('btn-cancelar').addEventListener('click', cancelarPedido);
