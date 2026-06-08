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
        geradoEm: new Date().toLocaleString('pt-BR')
    };
    output.textContent = JSON.stringify(payload, null, 2);
}

const formCliente = document.getElementById('form-cliente');

formCliente.addEventListener('submit', async (e) => {

    e.preventDefault();

    const dto = {

        nome: document.getElementById('cliente-nome').value,

        sobrenome: document.getElementById('cliente-sobrenome').value,

        cpf: document.getElementById('cliente-cpf').value,

        statusId: parseInt(
            document.getElementById('cliente-status').value
        ),

        dataNascimento:
            document.getElementById('cliente-dataNascimento').value,

        nomeSocial:
            document.getElementById('cliente-nomeSocial').value || null,

        sobrenomeSocial:
            document.getElementById('cliente-sobrenomeSocial').value || null,

        email:
            document.getElementById('cliente-email').value,

        telefone:
            document.getElementById('cliente-telefone').value,

        cep:
            document.getElementById('cliente-cep').value,

        numero:
            document.getElementById('cliente-numero').value,

        logradouro:
            document.getElementById('cliente-logradouro').value,

        bairro:
            document.getElementById('cliente-bairro').value,

        cidade:
            document.getElementById('cliente-cidade').value,

        uf:
            document.getElementById('cliente-uf').value,

        complemento:
            document.getElementById('cliente-complemento').value || null,

        login:
            document.getElementById('cliente-login').value,

        hashSenha:
            document.getElementById('cliente-hashSenha').value
    };

    try {

        const response = await fetch(
            'http://localhost:8080/clientes',
            {
                method: 'POST',

                headers: {
                    'Content-Type': 'application/json'
                },

                body: JSON.stringify(dto)
            }
        );

        const texto = await response.text();

        document.getElementById('output').textContent = texto;

        if (response.ok) {

            alert('Cliente cadastrado com sucesso!');

            formCliente.reset();
        }

    } catch (error) {

        console.error(error);

        document.getElementById('output').textContent =
            'Erro ao conectar com a API';
    }
});

window.addEventListener('load', () => {
    addListField('fornecedor-telefones', 'Telefone', 'telefones[]');
    addListField('fornecedor-emails', 'Email', 'emails[]');
    addListField('pedido-itens', 'Produto ID', 'produtos[]');
});

const formProduto = document.getElementById('form-produto');

formProduto.addEventListener('submit', async (e) => {

    e.preventDefault();

    const dto = {

        nome: document.getElementById('produto-nome').value,
        descricao: document.getElementById('produto-descricao').value,
        preco: parseFloat(document.getElementById('produto-precoVenda').value),
        custo: parseFloat(document.getElementById('produto-custo').value),
        estoque: parseInt(document.getElementById('produto-estoque').value),
        imagemurl: document.getElementById('produto-imagemurl').value
    };

    try {

        const response = await fetch(
            'http://localhost:8080/produtos',
            {
                method: 'POST',

                headers: {
                    'Content-Type': 'application/json'
                },

                body: JSON.stringify(dto)
            }
        );

        const texto = await response.text();

        document.getElementById('output').textContent = texto;

        if (response.ok) {

            alert('Produto cadastrado com sucesso!');

            formProduto.reset();
        }

    } catch (error) {

        console.error(error);

        document.getElementById('output').textContent =
            'Erro ao conectar com a API';
    }

    const formPedido = document.getElementById('form-pedido');

    formPedido.addEventListener('submit', async (e) => {

        e.preventDefault();

        const dto = {

            clienteId: parseInt(document.getElementById('pedido-clienteId').value),
            dataPedido: document.getElementById('pedido-dataPedido').value,
            status: parseInt(document.getElementById('pedido-status').value),
            itens: Array.from(document.querySelectorAll('#pedido-itens .field-row input'))
                .map(input => parseInt(input.value))
        };

        try {

            const response = await fetch(
                'http://localhost:8080/pedidos',
                {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(dto)
                }
            );

            const texto = await response.text();

            document.getElementById('output').textContent = texto;

            if (response.ok) {

                alert('Pedido cadastrado com sucesso!');

                formPedido.reset();
            }

        } catch (error) {

            console.error(error);
            document.getElementById('output').textContent = 'Erro ao conectar com a API';
        }
})});
