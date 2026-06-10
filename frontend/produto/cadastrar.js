const API_URL = 'http://localhost:8080/produtos';
const API_FORNECEDORES = 'http://localhost:8080/fornecedores/ativos';

/* =========================
   POPULAR SELECT DE FORNECEDORES
========================= */
async function carregarFornecedores() {
    const select = document.getElementById('fornecedorId');

    try {
        const response = await apiFetch(API_FORNECEDORES);

        if (!response.ok) throw new Error('Erro ao buscar fornecedores');

        const fornecedores = await response.json();

        select.innerHTML = '<option value="" disabled selected>Selecione um fornecedor</option>';

        fornecedores.forEach(f => {
            const option = document.createElement('option');
            option.value = f.idFornecedor;
            option.textContent = f.nome;
            select.appendChild(option);
        });

    } catch (error) {
        console.error(error);
        select.innerHTML = '<option value="" disabled selected>Erro ao carregar fornecedores</option>';
    }
}

/* =========================
   SUBMIT — CADASTRAR PRODUTO
========================= */
document.getElementById('form-produto').addEventListener('submit', async (e) => {
    e.preventDefault();

    const dto = {
        nome: document.getElementById('nome').value,
        descricao: document.getElementById('descricao').value,
        precoVenda: limparMascaraDinheiro(document.getElementById('precoVenda').value),
        precoCusto: limparMascaraDinheiro(document.getElementById('precoCusto').value),
        estoque: parseInt(document.getElementById('estoque').value),
        fornecedorId: parseInt(document.getElementById('fornecedorId').value),
        imagemUrl: document.getElementById('imagemUrl').value || null
    };

    console.log(dto);
    console.log(typeof dto.fornecedorId);

    try {
        const response = await apiFetch(API_URL, {
            method: 'POST',
            body: JSON.stringify(dto)
        });

        const texto = await response.text();
        document.getElementById('output').textContent = texto;

        if (response.ok) {
            alert('Produto cadastrado com sucesso!');
            document.getElementById('form-produto').reset();
            carregarFornecedores();
        }

    } catch (error) {
        console.error(error);
        document.getElementById('output').textContent = 'Erro ao conectar com a API';
    }
});

/* =========================
   INIT
========================= */
document.addEventListener('DOMContentLoaded', () => {
    carregarFornecedores()

    inserirMascaraDinheiro(document.getElementById('precoVenda'))
    inserirMascaraDinheiro(document.getElementById('precoCusto'))
});
