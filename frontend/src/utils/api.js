const BASE = 'http://localhost:8080';

export async function apiFetch(path, options = {}) {
  const token = localStorage.getItem('token');

  const headers = {
    'Content-Type': 'application/json',
    ...(token ? { Authorization: `Bearer ${token}` } : {}),
    ...(options.headers ?? {}),
  };

  const response = await fetch(`${BASE}${path}`, { ...options, headers });

  if (response.status === 401 || response.status === 403) {
    localStorage.clear();
    window.location.hash = '#login';
    return null;
  }

  return response;
}

export function isAdmin() {
  return localStorage.getItem('tipo') === 'ADMIN';
}

export function isColab() {
  return localStorage.getItem('tipo') === 'COLABORADOR';
}

export function isCliente() {
  return localStorage.getItem('tipo') === 'CLIENTE';
}

export function formatarMoeda(value) {
  if (value === null || value === undefined) return '-';
  return Number(value).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
}

export function formatarDataHora(value) {
  if (!value) return '-';
  return new Date(value).toLocaleString('pt-BR');
}
