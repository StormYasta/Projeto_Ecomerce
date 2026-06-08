const panels = document.querySelectorAll('.panel');
const navButtons = document.querySelectorAll('.nav-bar button');
const output = document.getElementById('output');

const addRowMap = {
    fornecedorTelefone: { containerId: 'fornecedor-telefones', label: 'Telefone', name: 'telefones[]' },
    fornecedorEmail: { containerId: 'fornecedor-emails', label: 'Email', name: 'emails[]' },
    pedidoItem: { containerId: 'pedido-itens', label: 'Produto ID', name: 'produtos[]' }
};

navButtons.forEach(button => {
    button.addEventListener('click', () => {
        const target = button.dataset.target;
        panels.forEach(panel => panel.classList.toggle('active', panel.id === target));
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
});

document.querySelectorAll('[data-add]').forEach(button => {
    button.addEventListener('click', () => {
        const key = button.dataset.add;
        const info = addRowMap[key];
        if (!info) return;
        addListField(info.containerId, info.label, info.name);
    });
});

function addListField(containerId, label, name) {
    const container = document.getElementById(containerId);
    const item = document.createElement('div');
    item.className = 'list-item';

    const fieldContainer = document.createElement('div');
    fieldContainer.className = 'field-row';
    const fieldLabel = document.createElement('label');
    fieldLabel.textContent = label;
    const fieldInput = document.createElement('input');
    fieldInput.name = name;
    fieldInput.type = name.includes('email') ? 'email' : 'text';
    fieldInput.required = true;
    fieldContainer.appendChild(fieldLabel);
    fieldContainer.appendChild(fieldInput);

    const removeButton = document.createElement('button');
    removeButton.type = 'button';
    removeButton.className = 'remove-button';
    removeButton.textContent = 'Remover';
    removeButton.addEventListener('click', () => item.remove());

    item.appendChild(fieldContainer);
    item.appendChild(removeButton);
    container.appendChild(item);
}

const forms = document.querySelectorAll('.entity-form');
forms.forEach(form => form.addEventListener('submit', handleSubmit));

function handleSubmit(event) {
    event.preventDefault();
    const form = event.target;
    const formData = new FormData(form);
    const entity = form.id.replace('form-', '');
    const data = collectFormData(entity, formData);
    saveEntity(entity, data);
    displayResult(entity, data);
}

function saveEntity(entity, data) {
    const storage = JSON.parse(localStorage.getItem('cadastros') || '{}');
    storage[entity] = storage[entity] || [];
    const key = data.id ?? data.pessoaId ?? data.login ?? null;

    if (key !== null) {
        const existingIndex = storage[entity].findIndex(item => item.id === key || item.pessoaId === key || item.login === key);
        if (existingIndex >= 0) {
            storage[entity][existingIndex] = { ...storage[entity][existingIndex], ...data };
            localStorage.setItem('cadastros', JSON.stringify(storage));
            return;
        }
    }

    storage[entity].push(data);
    localStorage.setItem('cadastros', JSON.stringify(storage));
}

function collectFormData(entity, formData) {
    const data = {};
    for (const [key, value] of formData.entries()) {
        if (key.endsWith('[]')) {
            const base = key.replace('[]', '');
            data[base] = data[base] || [];
            data[base].push(value);
            continue;
        }
        const parsed = parseValue(value);
        data[key] = parsed;
    }
    if (entity === 'pedido' && data.produtos) {
        data.produtos = Array.isArray(data.produtos) ? data.produtos : [data.produtos];
    }
    return data;
}

function parseValue(value) {
    if (!value) return value;
    if (!isNaN(value) && value.trim() !== '') return Number(value);
    return value;
}

function displayResult(entity, data) {
    const payload = {
        entidade: entity,
        dados: data,
        atualizadoEm: new Date().toLocaleString('pt-BR')
    };
    output.textContent = JSON.stringify(payload, null, 2);
}

window.addEventListener('load', () => {
    addListField('fornecedor-telefones', 'Telefone', 'telefones[]');
    addListField('fornecedor-emails', 'Email', 'emails[]');
    addListField('pedido-itens', 'Produto ID', 'produtos[]');
});
