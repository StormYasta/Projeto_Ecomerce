/////////////////////////////////////////////////////
// MASCARA E FORMATO PARA CPF
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

function formatarCpf(cpf) {
    cpf = cpf.replace(/\D/g, '').slice(0, 11);

    return cpf
        .replace(/(\d{3})(\d)/, '$1.$2')
        .replace(/(\d{3})(\d)/, '$1.$2')
        .replace(/(\d{3})(\d{1,2})$/, '$1-$2');
}
/////////////////////////////////////////////////////
// MASCARA E FORMATO PARA CEP 
function inserirMascaraCep(campo) {
    campo.addEventListener('input', function () {
        let cep = this.value.replace(/\D/g, '').slice(0, 8);

        cep = cep.replace(/(\d{5})(\d)/, '$1-$2');

        this.value = cep;
    });
}

function formatarCep(cep) {
    cep = cep.replace(/\D/g, '').slice(0, 8);

    return cep.replace(/(\d{5})(\d)/, '$1-$2');
}
/////////////////////////////////////////////////////
// MASCARA E FORMATO PARA DATA
function inserirMascaraData(campo) {
    campo.addEventListener('input', function () {
        let data = this.value.replace(/\D/g, '').slice(0, 8);

        data = data
            .replace(/(\d{2})(\d)/, '$1/$2')
            .replace(/(\d{2})(\d)/, '$1/$2');

        this.value = data;
    });
}

function formatarData(data) {
    if (!data) return null;

    const partes = data.split('/');

    if (partes.length !== 3) return null;

    const [dia, mes, ano] = partes;

    return `${ano}-${mes}-${dia}`;
}

/////////////////////////////////////////////////////
// MASCARA E FORMATO PARA CELULAR
function inserirMascaraTelefone(campo) {
    campo.addEventListener('input', function () {
        let tel = this.value.replace(/\D/g, '').slice(0, 13);

        // adiciona o +55 automaticamente
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

function formatarTelefone(telefone) {
    return telefone.replace(/\D/g, '').slice(0, 13);
}

/////////////////////////////////////////////////////
// MASCARA E FORMATO PARA CNPJ
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

function formatarCnpj(cnpj) {
    return cnpj.replace(/\D/g, '');
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

function formatarDinheiro(valor) {
    if (!valor) return null;

    const numeros = valor.replace(/\D/g, '');

    if (!numeros) return null;

    return parseInt(numeros, 10) / 100;
}