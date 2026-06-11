export function maskCpf(value) {
  return value
    .replace(/\D/g, '')
    .slice(0, 11)
    .replace(/(\d{3})(\d)/, '$1.$2')
    .replace(/(\d{3})(\d)/, '$1.$2')
    .replace(/(\d{3})(\d{1,2})$/, '$1-$2');
}

export function maskCep(value) {
  return value
    .replace(/\D/g, '')
    .slice(0, 8)
    .replace(/(\d{5})(\d)/, '$1-$2');
}

export function maskTelefone(value) {
  let tel = value.replace(/\D/g, '').slice(0, 13);
  tel = tel.replace(/^(\d{2})(\d)/, '+$1 ($2');
  tel = tel.replace(/^\+(\d{2}) \((\d{2})(\d)/, '+$1 ($2) $3');
  tel = tel.replace(/(\d{5})(\d)/, '$1-$2');
  return tel;
}

export function maskCnpj(value) {
  return value
    .replace(/\D/g, '')
    .slice(0, 14)
    .replace(/^(\d{2})(\d)/, '$1.$2')
    .replace(/^(\d{2})\.(\d{3})(\d)/, '$1.$2.$3')
    .replace(/\.(\d{3})(\d)/, '.$1/$2')
    .replace(/(\d{4})(\d)/, '$1-$2');
}

export function maskDinheiro(value) {
  let v = value.replace(/\D/g, '');
  if (!v) return '';
  v = (parseInt(v, 10) / 100).toFixed(2);
  let [inteiro, decimal] = v.split('.');
  inteiro = inteiro.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
  return `R$ ${inteiro},${decimal}`;
}

export function cleanDinheiro(value) {
  if (!value) return null;
  return value
    .replace(/R\$\s?/g, '')
    .replace(/\./g, '')
    .replace(',', '.')
    .trim();
}

export function cleanDigits(value) {
  return (value ?? '').replace(/\D/g, '');
}
