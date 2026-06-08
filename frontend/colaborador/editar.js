const API_URL = 'http://localhost:8080/colaboradores';

const output = document.getElementById('output');

/* =========================
   BUSCAR COLABORADOR POR ID
========================= */
async function buscarColaboradorPorId(id) {
    if (!id) {
        alert('Informe um ID válido');
        return;
    }

    try {
        const response = await fetch(`${API_URL}/${id}`);

        if (!response.ok) {
            throw new Error('Colaborador não encontrado');
        }

        const colaborador = await response.json();

        preencherFormularioColaborador(colaborador);

        output.textContent = JSON.stringify({
            mensagem: 'Colaborador carregado com sucesso',
            colaborador
        }, null, 2);

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao buscar colaborador';
    }
}

/* =========================
   PREENCHER FORMULÁRIO
========================= */
async function preencherFormularioColaborador(colaborador) {

    setValue('pessoaId',        colaborador.idColaborador ?? colaborador.pessoaId);
    setValue('nome',            colaborador.nome);
    setValue('sobrenome',       colaborador.sobrenome);
    setValue('cpf',             formatarCpf(colaborador.cpf));
    setValue('dataNascimento',  formatarData(colaborador.dataNascimento));
    setValue('salarioAtual',    colaborador.salarioAtual);
    setValue('dataResgistro',   formatarData(colaborador.dataRegistro));
    setValue('numeroCTPS',      colaborador.numCarteiraTrabalho);
    setValue('numeroCNH',       colaborador.numCNH);

}
/* =========================
   ATUALIZAR COLABORADOR (PUT)
========================= */
async function atualizarColaborador(event) {
    event.preventDefault();

    const form = event.target;
    const formData = new FormData(form);

    const data = {};

    for (const [key, value] of formData.entries()) {
        data[key] = value;
    }

    data.statusId   = parseInt(data.statusId);
    data.funcao     = parseInt(data.funcao);
    data.salarioAtual = parseFloat(data.salarioAtual);

    const id = data.pessoaId;

    if (!id) {
        alert('ID do colaborador é obrigatório');
        return;
    }

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
            alert('Colaborador atualizado com sucesso!');
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao atualizar colaborador';
    }
}

/* =========================
   INATIVAR COLABORADOR (DELETE)
========================= */
async function inativarColaborador() {

    const id = document.querySelector('[name="pessoaId"]').value;

    if (!id) {
        alert('Carregue um colaborador antes de inativar');
        return;
    }

    const confirmar = confirm('Tem certeza que deseja inativar este colaborador?');

    if (!confirmar) return;

    try {
        const response = await fetch(`${API_URL}/${id}`, {
            method: 'DELETE'
        });

        const text = await response.text();

        output.textContent = JSON.stringify({
            status: response.status,
            resposta: text
        }, null, 2);

        if (response.ok) {
            alert('Colaborador inativado com sucesso!');
            limparCampos();
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao inativar colaborador';
    }
}

/* =========================
   HELPERS
========================= */
function setValue(name, value) {
    const field = document.querySelector(`[name="${name}"]`);
    if (!field) return;
    field.value = value ?? '';
}

function limparCampos() {
    document.getElementById('form-colaborador').reset();

    const idField = document.querySelector('[name="pessoaId"]');
    if (idField) {
        idField.readOnly = false;
        idField.value = '';
    }

    const searchField = document.getElementById('search-id');
    if (searchField) searchField.value = '';

    output.textContent = 'Aguardando operação...';
}

/* =========================
   EVENTOS
========================= */
document.getElementById('btn-search').addEventListener('click', () => {
    const id = document.getElementById('search-id').value;
    buscarColaboradorPorId(id);
});

document.getElementById('form-colaborador')
    .addEventListener('submit', atualizarColaborador);

document.getElementById('btn-delete')
    .addEventListener('click', inativarColaborador);

document.addEventListener('DOMContentLoaded', () => {
    inserirMascaraCpf(cpf);
    inserirMascaraDinheiro(salario);
    inserirMascaraData(dataNascimento);
    inserirMascaraData(dataRegistro);
});