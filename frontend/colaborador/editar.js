const API_URL = 'http://localhost:8080/colaboradores';

const formColaborador = document.getElementById('form-colaborador');
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
        const response = await apiFetch(`${API_URL}/${id}`);

        if (!response.ok) {
            throw new Error('Colaborador não encontrado');
        }

        const colab = await response.json();

        preencherFormulario(colab);

        output.textContent = JSON.stringify(colab, null, 2);

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao buscar colaborador';
    }
}

/* =========================
   PREENCHER FORMULÁRIO
========================= */
function preencherFormulario(c) {

    formColaborador.reset();

    document.getElementById('pessoaId').value = c.pessoaId ?? c.idColaborador
    document.getElementById('nome').value = c.nome
    document.getElementById('sobrenome').value = c.sobrenome
    document.getElementById('cpf').value = c.cpf
    document.getElementById('statusId').value = c.statusId
    document.getElementById('salario').value = c.salarioAtual
    document.getElementById('dataRegistro').value = c.dataRegistro
    document.getElementById('dataNascimento').value = c.dataNascimento
    document.getElementById('numCTPS').value = c.numCarteiraTrabalho
    document.getElementById('numCNH').value = c.numCNH

    document.getElementById('salario').dispatchEvent(new Event('input'))

    formColaborador.querySelector('[name="pessoaId"]').readOnly = true;
}

/* =========================
   ATUALIZAR COLABORADOR
========================= */
formColaborador.addEventListener('submit', async (e) => {
    e.preventDefault();

    const dto = {
        pessoaId: Number(document.getElementById('pessoaId').value),
        nome: document.getElementById('nome').value,
        sobrenome: document.getElementById('sobrenome').value,
        cpf: document.getElementById('cpf').value.replace(/\D/g, ''),
        statusId: parseInt(document.getElementById('statusId').value),
        dataNascimento: document.getElementById('dataNascimento').value,
        dataRegistro: document.getElementById('dataRegistro').value,
        funcao: obterIdFuncao(document.getElementById('funcao').value),
        salarioAtual: limparMascaraDinheiro(document.getElementById('salario').value),
        numeroCTPS: document.getElementById('numCTPS').value.replace(/\D/g, ''),
        numeroCNH: document.getElementById('numCNH').value.replace(/\D/g, '')
    };

    console.log(dto)

    try {
        const response = await apiFetch(`${API_URL}/${dto.pessoaId}`, {
            method: 'PUT',
            body: JSON.stringify(dto)
        });

        const text = await response.text();

        output.textContent = text;

        if (response.ok) {
            alert('Colaborador atualizado com sucesso!');
            formColaborador.reset();
        }

    } catch (error) {
        console.error(error);
        output.textContent = 'Erro ao atualizar colaborador';
    }
});

/* =========================
   INATIVAR
========================= */
async function inativarColaborador() {

    const id = get('pessoaId');

    if (!id) {
        alert('Carregue um colaborador primeiro');
        return;
    }

    if (!confirm('Deseja inativar este colaborador?')) return;

    try {
        const response = await apiFetch(`${API_URL}/${id}`, {
            method: 'DELETE'
        });

        const text = await response.text();

        output.textContent = text;

        if (response.ok) {
            alert('Colaborador inativado');
            formColaborador.reset();
        }

    } catch (error) {
        console.error(error);
    }
}


async function carregarFuncoesColaborador() {
    try {
        const response = await apiFetch('http://localhost:8080/funccolaboradores');

        if (!response.ok) {
            throw new Error('Erro ao buscar funções');
        }

        const funcoes = await response.json();

        const datalist = document.getElementById('lista-funcoes');

        datalist.innerHTML = '';

        funcoes
            .filter(f => f.ativo)
            .forEach(funcao => {
                const option = document.createElement('option');

                option.value = funcao.descricao;

                option.dataset.id = funcao.id;

                datalist.appendChild(option);
            });

    } catch (error) {
        console.error(error);
    }
}

function obterIdFuncao(descricao) {
    const options = document.querySelectorAll('#lista-funcoes option');

    for (const opt of options) {
        if (opt.value === descricao.toUpperCase()) {
            return parseInt(opt.dataset.id);
        }
    }

    return null;
}

/* =========================
   HELPERS
========================= */

function setValue(name, value) {
    const el = document.querySelector(`[name="${name}"]`);
    if (el) el.value = value ?? '';
}

function get(name) {
    const el = document.querySelector(`[name="${name}"]`);
    return el ? el.value : '';
}

function limpar(v) {
    return (v ?? '').toString().replace(/\D/g, '');
}

/* dinheiro */
function formatarDinheiro(v) {
    if (!v) return null;
    const n = limpar(v);
    return n ? (parseInt(n) / 100).toFixed(2) : null;
}

/* =========================
   INIT
========================= */
document.addEventListener('DOMContentLoaded', () => {

    carregarFuncoesColaborador();

    const cpf = document.querySelector('[name="cpf"]');
    const salario = document.querySelector('[name="salario"]');

    inserirMascaraCpf(cpf);
    inserirMascaraDinheiro(salario);

    document.getElementById('btn-search')
        .addEventListener('click', () => {
            const id = document.getElementById('search-id').value;
            buscarColaboradorPorId(id);
        });

    document.getElementById('btn-delete')
        .addEventListener('click', inativarColaborador);
});

function formatarDataInput(v) {
    if (!v) return '';

    // caso venha ISO com hora
    return v.split('T')[0];
}