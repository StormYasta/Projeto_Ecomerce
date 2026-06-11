import { useState, useEffect } from 'react';
import { apiFetch } from '../utils/api';

export function useFornecedoresAtivos() {
  const [fornecedores, setFornecedores] = useState([]);

  useEffect(() => {
    apiFetch('/fornecedores/ativos')
      .then((r) => r && r.ok ? r.json() : [])
      .then(setFornecedores)
      .catch(() => {});
  }, []);

  return fornecedores;
}
