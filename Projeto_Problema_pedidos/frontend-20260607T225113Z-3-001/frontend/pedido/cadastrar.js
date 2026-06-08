const API_PEDIDOS = 'http://localhost:8080/pedidos';
const API_CLIENTES = 'http://localhost:8080/clientes';
const API_PRODUTOS = 'http://localhost:8080/produtos';
const API_STATUS = 'http://localhost:8080/pedidos/status';

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

document.getElementById('form-pedido').addEventListener('submit', async (e) => {
    e.preventDefault();

    const dto = {
        clienteId: document.getElementById('clienteId').value,
        produtoId: document.getElementById('produtoId').value,
        statusId: parseInt(document.getElementById('statusId').value),
        dataPedido: formatarData(document.getElementById('dataPedido').value)
    };

    console.log(dto);
    console.log(typeof dto.pedidoId);

    try {
        const response = await fetch(API_PEDIDOS, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(dto)
        });

        const texto = await response.text();
        document.getElementById('output').textContent = texto;

        if (response.ok) {
            alert('Pedido cadastrado com sucesso!');
            document.getElementById('form-pedido').reset();
            carregarClientes();
            carregarProdutos();
            carregarStatus();
        }

    } catch (error) {
        console.error(error);
        document.getElementById('output').textContent = 'Erro ao conectar com a API';
    }
});

document.addEventListener('DOMContentLoaded', () => {
    carregarClientes();
    carregarProdutos();
    carregarStatus();
    inserirMascaraData(dataPedido);
});
