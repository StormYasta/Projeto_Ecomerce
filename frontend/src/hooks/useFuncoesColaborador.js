import { useState, useEffect } from 'react';
import { apiFetch } from '../utils/api';

export function useFuncoesColaborador() {
  const [funcoes, setFuncoes] = useState([]);

  useEffect(() => {
    apiFetch('/funccolaboradores')
      .then((r) => r && r.ok ? r.json() : [])
      .then((data) => setFuncoes(data.filter((f) => f.ativo)))
      .catch(() => {});
  }, []);

  function obterIdFuncao(descricao) {
    const f = funcoes.find((f) => f.descricao === descricao.toUpperCase());
    return f ? f.id : null;
  }

  return { funcoes, obterIdFuncao };
}
