import { useState } from 'react';

export default function Login({ onLogin }) {
  const [login, setLogin] = useState('');
  const [senha, setSenha] = useState('');
  const [status, setStatus] = useState('Aguardando login...');

  async function handleSubmit(e) {
    e.preventDefault();
    try {
      const response = await fetch('http://localhost:8080/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ login, senha }),
      });

      if (!response.ok) {
        setStatus('Login ou senha inválidos');
        return;
      }

      const result = await response.json();
      localStorage.setItem('token', result.token);
      localStorage.setItem('tipo', result.tipo);
      localStorage.setItem('pessoaId', result.pessoaId);
      localStorage.setItem('nome', result.nome);
      localStorage.setItem('loggedIn', 'true');

      setStatus(`Bem-vindo, ${result.nome}! Redirecionando...`);
      setTimeout(() => onLogin(), 800);
    } catch {
      setStatus('Erro ao conectar com o servidor');
    }
  }

  return (
    <>
      <header className="topbar">
        <div className="brand">Login do Sistema</div>
      </header>

      <main className="page">
        <section className="panel active">
          <h2>Acessar sistema</h2>
          <form className="entity-form" onSubmit={handleSubmit}>
            <div className="field-row">
              <label>Login</label>
              <input type="text" value={login} onChange={(e) => setLogin(e.target.value)} required />
            </div>
            <div className="field-row">
              <label>Senha</label>
              <input type="password" value={senha} onChange={(e) => setSenha(e.target.value)} required />
            </div>
            <button type="submit">Entrar</button>
          </form>
        </section>
      </main>

      <aside className="output-panel">
        <h3>Status</h3>
        <pre>{status}</pre>
      </aside>
    </>
  );
}
