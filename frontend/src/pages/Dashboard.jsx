import { isAdmin, isColab } from '../utils/api';

export default function Dashboard() {
  const tipo = localStorage.getItem('tipo');
  const nome = localStorage.getItem('nome');

  function handleLogout() {
    localStorage.clear();
    window.location.hash = '#login';
  }

  return (
    <div className="container">
      <aside className="sidebar">
        <h3>Menu</h3>

        {isAdmin() ? (
          <>
            <a className="nav-item" href="#cliente/visualizar">Clientes</a>
            <a className="nav-item" href="#colaborador/visualizar">Colaboradores</a>
            <a className="nav-item" href="#fornecedor/visualizar">Fornecedores</a>
            <a className="nav-item" href="#produto/visualizar">Produtos</a>
            <a className="nav-item" href="#pedido/cadastrar">Pedidos</a>
          </>
        ) : isColab() ? (
          <>
            <a className="nav-item" href="#cliente/visualizar">Clientes</a>
            <a className="nav-item" href="#fornecedor/visualizar">Fornecedores</a>
            <a className="nav-item" href="#produto/visualizar">Produtos</a>
            <a className="nav-item" href="#pedido/cadastrar">Pedidos</a>
          </>
        ) : (
          <>
            <a className="nav-item" href="#loja/visualizar">Loja</a>
            <a className="nav-item" href="#meuspedidos/visualizar">Meus Pedidos</a>
          </>
        )}

        <a className="nav-item" href="#login" onClick={(e) => { e.preventDefault(); handleLogout(); }}>
          Sair
        </a>
      </aside>

      <main className="content">
        <div className="card">
          <h2>Bem-vindo{nome ? `, ${nome}` : ''}</h2>
          <p>
            {tipo === 'ADMIN' || 'COLABORADOR'
              ? 'Selecione um item do menu ao lado para visualizar os dados.'
              : 'Acesse seus pedidos ou nossa loja pelo menu ao lado.'}
          </p>
        </div>
      </main>
    </div>
  );
}
