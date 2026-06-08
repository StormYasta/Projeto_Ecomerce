const API_BASE = window.location.origin.includes('8080') ? '' : 'http://localhost:8080';
const API_URL = `${API_BASE}/pedidos`;
const API_CLIENTES = `${API_BASE}/clientes`;
const API_PRODUTOS = `${API_BASE}/produtos`;
const API_STATUS = `${API_BASE}/pedidos/status`;
const output = document.getElementById('output');

function parseBigInt(value) {
    try {
        return BigInt(value);
    } catch {
        return null;
    }
}

async function carregarClientes(selecionado = null) {
    const select = document.getElementById('clienteId');
    select.innerHTML = '<option value="" disabled selected>Carregando clientes...</option>';

    try {
        const response = await fetch(API_CLIENTES);
        if (!response.ok) throw new Error('Erro ao buscar clientes');

        const clientes = await response.json();
        select.innerHTML = '<option value="" disabled selected>Selecione um cliente</option>';

        clientes.forEach(cliente => {
            const id = cliente.idCliente ?? cliente.id ?? cliente.pessoaId;
            if (!id) return;

            const option = document.createElement('option');
            option.value = id.toString();
            option.textContent = `${cliente.nome} ${cliente.sobrenome ?? ''} (#${id})`;
            if (selecionado && selecionado.toString() === id.toString()) {
                option.selected = true;
            }
            select.appendChild(option);
        });

    } catch (error) {
        console.error(error);
        select.innerHTML = '<option value="" disabled selected>Erro ao carregar clientes</option>';
    }
}

async function carregarProdutos(selecionado = null) {
    const select = document.getElementById('produtoId');
    select.innerHTML = '<option value="" disabled selected>Carregando produtos...</option>';

    try {
        const response = await fetch(API_PRODUTOS);
        if (!response.ok) throw new Error('Erro ao buscar produtos');

        const produtos = await response.json();
        select.innerHTML = '<option value="" disabled selected>Selecione um produto</option>';

        produtos.forEach(produto => {
            const id = produto.idProduto ?? produto.id;
            if (!id) return;

            const option = document.createElement('option');
            option.value = id.toString();
            option.textContent = `${produto.nome} (#${id})`;
            if (selecionado && selecionado.toString() === id.toString()) {
                option.selected = true;
            }
            select.appendChild(option);
        });

    } catch (error) {
        console.error(error);
        select.innerHTML = '<option value="" disabled selected>Erro ao carregar produtos</option>';
    }
}

async function carregarStatus(selecionado = null) {
    const select = document.getElementById('statusId');
    select.innerHTML = '<option value="" disabled selected>Carregando status...</option>';

    try {
        const response = await fetch(API_STATUS);
        if (!response.ok) throw new Error('Erro ao buscar status');

        const statuses = await response.json();
        if (!Array.isArray(statuses) || statuses.length === 0) {
            throw new Error('Nenhum status retornado');
        }

        select.innerHTML = '<option value="" disabled selected>Selecione um status</option>';

        statuses.forEach(status => {
            const id = status.id ?? status.statusId ?? status.value;
            const label = status.descricao ?? status.nome ?? status.label ?? `Status ${id}`;
            if (id === undefined || id === null) return;

            const option = document.createElement('option');
            option.value = id.toString();
            option.textContent = label;
            if (selecionado && selecionado.toString() === id.toString()) {
                option.selected = true;
            }
            select.appendChild(option);
        });

    } catch (error) {
        console.error(error);
        select.innerHTML = '<option value="" disabled selected>ATIVO</option>' +
            '<option value="1">ATIVO</option>' +
            '<option value="2">INATIVO</option>' +
            '<option value="3">BLOQUEADO</option>';
    }
}

async function buscarPedidoPorId(id) {
    if (!id) {
        alert('Informe um ID válido');
        return;
    }

    try {
        const response = await fetch(`${API_URL}/${id}`);
        if (!response.ok) throw new Error('Pedido não encontrado');

        const pedido = await response.json();
        await Promise.all([
            carregarClientes(pedido.clienteId),
            carregarProdutos(pedido.produtoId),
            carregarStatus(pedido.statusId)
        ]);

        preencherFormularioPedido(pedido);

        output.textContent = JSON.stringify({
            mensagem: 'Pedido carregado com sucesso',
            pedido
        }, null, 2);

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao buscar pedido';
    }
}

function preencherFormularioPedido(pedido) {
    setValue('id', pedido.id);
    setValue('clienteId', pedido.clienteId);
    setValue('produtoId', pedido.produtoId);
    setValue('statusId', pedido.statusId);
    setValue('dataPedido', converterDataParaMascara(pedido.dataPedido));

    const idField = document.getElementById('id');
    if (idField) idField.readOnly = true;
}

function converterDataParaMascara(date) {
    if (!date) return '';
    const isoDate = date.split('T')[0];
    const [ano, mes, dia] = isoDate.split('-');
    return `${dia}/${mes}/${ano}`;
}

async function atualizarPedido(event) {
    event.preventDefault();

    const form = event.target;
    const formData = new FormData(form);
    const data = {};

    for (const [key, value] of formData.entries()) {
        data[key] = value;
    }

    const id = data.id;
    if (!id) {
        alert('ID do pedido é obrigatório');
        return;
    }

    const clienteId = parseBigInt(data.clienteId);
    const produtoId = parseBigInt(data.produtoId);
    const statusId = parseInt(data.statusId, 10);

    if (!clienteId || !produtoId || !Number.isInteger(statusId)) {
        alert('IDs de cliente/produto devem ser válidos e status deve ser inteiro.');
        return;
    }

    data.clienteId = clienteId.toString();
    data.produtoId = produtoId.toString();
    data.statusId = statusId;
    data.dataPedido = formatarData(data.dataPedido);

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
            alert('Pedido atualizado com sucesso!');
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao atualizar pedido';
    }
}

function setValue(name, value) {
    const field = document.querySelector(`[name="${name}"]`);
    if (!field) return;
    field.value = value ?? '';
}

// eventos

document.getElementById('btn-search').addEventListener('click', () => {
    const id = document.getElementById('search-id').value;
    buscarPedidoPorId(id);
});

document.getElementById('form-pedido')
    .addEventListener('submit', atualizarPedido);

document.addEventListener('DOMContentLoaded', () => {
    carregarClientes();
    carregarProdutos();
    carregarStatus();
    inserirMascaraData(dataPedido);
});
