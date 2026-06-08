const formColaborador = document.getElementById('form-colaborador');

formColaborador.addEventListener('submit', async (e) => {
    e.preventDefault();

    const dto = {
        nome: document.getElementById('nome').value,
        sobrenome: document.getElementById('sobrenome').value,
        cpf: document.getElementById('cpf').value.replace(/\D/g, ''),
        statusId: parseInt(document.getElementById('statusId').value),

        dataNascimento: formatarData(
            document.getElementById('dataNascimento').value
        ),

        email: document.getElementById('email').value,

        telefone: document
            .getElementById('telefone')
            .value.replace(/\D/g, ''),

        cep: document
            .getElementById('cep')
            .value.replace(/\D/g, ''),

        numero: document.getElementById('numero').value,
        logradouro: document.getElementById('logradouro').value,
        bairro: document.getElementById('bairro').value,
        cidade: document.getElementById('cidade').value,
        uf: document.getElementById('uf').value,

        complemento:
            document.getElementById('complemento').value || null,

        funcao: obterIdFuncao(
            document.getElementById('funcao').value
        ),

        salarioInicial: parseFloat(
            formatarDinheiro(document.getElementById('salario'))
        ),

        dataResgistro: formatarData(
            document.getElementById('dataRegistro').value
        ),

        numeroCTPS: document.getElementById('numCTPS').value,

        numeroCNH: document.getElementById('numCNH').value,

        login: document.getElementById('login').value,

        hashSenha: document.getElementById('senha').value
    };

    try {

        const response = await fetch(
            'http://localhost:8080/colaboradores',
            {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(dto)
            }
        );

        const texto = await response.text();

        output.textContent = texto;
        console.log(dto)

        if (response.ok) {

            alert('Colaborador cadastrado com sucesso!');

            formColaborador.reset();

            document.getElementById('telefone').value = '+55';
        }

    } catch (error) {

        console.error(error);

        output.textContent =
            'Erro ao conectar com a API';
    }
});

async function carregarFuncoesColaborador() {
    try {
        const response = await fetch('http://localhost:8080/funccolaboradores');

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

                // o usuário vê a descrição
                option.value = funcao.descricao;

                // guarda o ID internamente via dataset
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
        if (opt.value === descricao) {
            return parseInt(opt.dataset.id);
        }
    }

    return null;
}

document.addEventListener('DOMContentLoaded', () => {
    
    carregarFuncoesColaborador();
    
    inserirMascaraCpf(cpf);
    inserirMascaraCep(cep);
    inserirMascaraDinheiro(salario);
    inserirMascaraData(dataNascimento);
    inserirMascaraData(dataRegistro);
    inserirMascaraTelefone(telefone);
});