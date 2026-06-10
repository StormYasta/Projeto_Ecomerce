/////////////////////////////////////////////////////
// MASCARA PARA CPF
function inserirMascaraCpf(campo) {
    campo.addEventListener('input', function () {
        let cpf = this.value.replace(/\D/g, '').slice(0, 11);

        cpf = cpf
            .replace(/(\d{3})(\d)/, '$1.$2')
            .replace(/(\d{3})(\d)/, '$1.$2')
            .replace(/(\d{3})(\d{1,2})$/, '$1-$2');

        this.value = cpf;
    });
}

/////////////////////////////////////////////////////
// MASCARA PARA CEP 
function inserirMascaraCep(campo) {
    campo.addEventListener('input', function () {
        let cep = this.value.replace(/\D/g, '').slice(0, 8);

        cep = cep.replace(/(\d{5})(\d)/, '$1-$2');

        this.value = cep;
    });
}

/////////////////////////////////////////////////////
// MASCARA PARA CELULAR
function inserirMascaraTelefone(campo) {
    campo.addEventListener('input', function () {
        let tel = this.value.replace(/\D/g, '').slice(0, 13);

        tel = tel.replace(/^(\d{2})(\d)/, '+$1 ($2');
        tel = tel.replace(/^\+(\d{2}) \((\d{2})(\d)/, '+$1 ($2) $3');
        tel = tel.replace(/(\d{5})(\d)/, '$1-$2');

        this.value = tel;
    });

    campo.addEventListener('focus', () => {
        const len = campo.value.length;
        campo.setSelectionRange(len, len);
    });
}
/////////////////////////////////////////////////////
// MASCARA PARA CNPJ
function inserirMascaraCnpj(input) {
    input.addEventListener('input', () => {
        let v = input.value.replace(/\D/g, '').slice(0, 14);
        v = v.replace(/^(\d{2})(\d)/, '$1.$2')
             .replace(/^(\d{2})\.(\d{3})(\d)/, '$1.$2.$3')
             .replace(/\.(\d{3})(\d)/, '.$1/$2')
             .replace(/(\d{4})(\d)/, '$1-$2');
        input.value = v;
    });
}
/////////////////////////////////////////////////////
// MASCARA E FORMATO PARA DINHEIRO
function inserirMascaraDinheiro(campo) {
    campo.addEventListener('input', function () {

        let valor = this.value.replace(/\D/g, '');

        if (!valor) {
            this.value = '';
            return;
        }

        // transforma em centavos
        valor = (parseInt(valor, 10) / 100).toFixed(2);

        // separa parte inteira e decimal
        let [inteiro, decimal] = valor.split('.');

        // adiciona separador de milhar
        inteiro = inteiro.replace(/\B(?=(\d{3})+(?!\d))/g, '.');

        this.value = `R$ ${inteiro},${decimal}`;
    });

    campo.addEventListener('focus', () => {
        const len = campo.value.length;
        campo.setSelectionRange(len, len);
    });
}

function limparMascaraDinheiro (value) {
    if (!value) return null;

    return value
        .replace(/R\$\s?/g, '')   // remove R$
        .replace(/\./g, '')       // remove pontos de milhar
        .replace(',', '.')        // troca vírgula por ponto
        .trim();
}

// ─────────────────────────────────────────────
//  Wrapper de fetch que injeta o token JWT
// ─────────────────────────────────────────────
async function apiFetch(url, options = {}) {
    const token = localStorage.getItem('token');

    const headers = {
        'Content-Type': 'application/json',
        ...(token ? { 'Authorization': `Bearer ${token}` } : {}),
        ...(options.headers ?? {})
    };

    const response = await fetch(url, { ...options, headers });

    // Token expirado ou inválido — redireciona para login
    if (response.status === 401 || response.status === 403) {
        localStorage.clear();
        window.location.href = 'login.html';
        return;
    }

    return response;
}

// ─────────────────────────────────────────────
//  Helpers de permissão
// ─────────────────────────────────────────────
function isAdmin() {
    return localStorage.getItem('tipo') === 'ADMIN';
}

function isCliente() {
    return localStorage.getItem('tipo') === 'CLIENTE';
}