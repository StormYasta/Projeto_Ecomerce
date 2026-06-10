const viewContent = document.getElementById('view-content');
const viewOutput = document.getElementById('view-output');
const refreshButton = document.getElementById('refresh-data');
const clearButton = document.getElementById('clear-data');

const API_URL = 'http://localhost:8080/clientes';

refreshButton.addEventListener('click', loadClientes);
clearButton.addEventListener('click', clearView);

window.addEventListener('load', loadClientes);

async function loadClientes() {
    try {
        viewContent.innerHTML = '<p>Carregando clientes...</p>';

        const response = await apiFetch(API_URL);

        if (!response.ok) {
            throw new Error('Erro ao buscar clientes');
        }

        const clientes = await response.json();

        renderClientes(clientes);

    } catch (error) {
        console.error(error);
        viewContent.innerHTML = '<p class="error">Erro ao carregar dados.</p>';
        viewOutput.textContent = 'Falha na requisição à API.';
    }
}

function renderClientes(clientes) {
    viewContent.innerHTML = '';

    if (!clientes || clientes.length === 0) {
        viewContent.innerHTML = '<p class="empty-state">Nenhum cliente encontrado.</p>';
        viewOutput.textContent = 'Sem registros.';
        return;
    }

    let total = clientes.length;

    clientes.forEach(cliente => {
        viewContent.appendChild(renderClienteCard(cliente));
    });

    viewOutput.textContent = `Total de clientes: ${total}`;
}

function renderClienteCard(cliente) {
    const card = document.createElement('div');
    card.className = 'record-card';

    const title = document.createElement('h3');
    title.textContent = `${cliente.nome} ${cliente.sobrenome} (#${cliente.idCliente})`;
    card.appendChild(title);

    const fields = {
        'CPF': cliente.cpf,
        'Data de Nascimento': cliente.dataNascimento,
        'Data Cadastro': cliente.dataCadastro,
        'Status': cliente.statusDescricao,
        'Email': cliente.email,
        'Telefone': cliente.telefone,
        'CEP': cliente.cep,
        'Número': cliente.numero,
        'Logradouro': cliente.logradouro,
        'Bairro': cliente.bairro,
        'Cidade': cliente.cidade,
        'UF': cliente.uf,
        'Complemento': cliente.complemento
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