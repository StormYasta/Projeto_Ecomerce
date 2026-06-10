const viewContent = document.getElementById('view-content');
const viewOutput = document.getElementById('view-output');
const refreshButton = document.getElementById('refresh-data');
const clearButton = document.getElementById('clear-data');

const API_URL = 'http://localhost:8080/colaboradores';

refreshButton.addEventListener('click', loadClientes);
clearButton.addEventListener('click', clearView);

window.addEventListener('load', loadClientes);

async function loadClientes() {
    try {
        viewContent.innerHTML = '<p>Carregando colaboradores...</p>';

        const response = await apiFetch(API_URL);

        if (!response.ok) {
            throw new Error('Erro ao buscar colaboradores');
        }

        const colaboradores = await response.json();

        renderClientes(colaboradores);

    } catch (error) {
        console.error(error);
        viewContent.innerHTML = '<p class="error">Erro ao carregar dados.</p>';
        viewOutput.textContent = 'Falha na requisição à API.';
    }
}

function renderClientes(colaboradores) {
    viewContent.innerHTML = '';

    if (!colaboradores || colaboradores.length === 0) {
        viewContent.innerHTML = '<p class="empty-state">Nenhum colaborador encontrado.</p>';
        viewOutput.textContent = 'Sem registros.';
        return;
    }

    let total = colaboradores.length;

    colaboradores.forEach(colaborador => {
        viewContent.appendChild(renderClienteCard(colaborador));
    });

    viewOutput.textContent = `Total de colaboradores: ${total}`;
}

function renderClienteCard(colaborador) {
    const card = document.createElement('div');
    card.className = 'record-card';

    const title = document.createElement('h3');
    title.textContent = `${colaborador.nome} ${colaborador.sobrenome} (#${colaborador.idColaborador})`;
    card.appendChild(title);

    const fields = {
        'CPF': colaborador.cpf,
        'Data de Nascimento': colaborador.dataNascimento,
        'Data Cadastro': colaborador.dataCadastro,
        'Status': colaborador.statusDescricao,
        'Email': colaborador.email,
        'Telefone': colaborador.telefone,
        'CEP': colaborador.cep,
        'Número': colaborador.numero,
        'Logradouro': colaborador.logradouro,
        'Bairro': colaborador.bairro,
        'Cidade': colaborador.cidade,
        'UF': colaborador.uf,
        'Complemento': colaborador.complemento
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