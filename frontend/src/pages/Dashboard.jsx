import { isAdmin, isColab } from '../utils/api';

const resumo = [
  { titulo: 'Faturamento total', valor: 'R$ 94.850,00', descricao: 'Soma das vendas no período analisado' },
  { titulo: 'Total de pedidos', valor: '184', descricao: 'Pedidos registrados no e-commerce' },
  { titulo: 'Ticket médio', valor: 'R$ 515,48', descricao: 'Valor médio por pedido' },
  { titulo: 'Taxa de cancelamento', valor: '5,5%', descricao: 'Pedidos cancelados sobre o total' },
];

const receitaMensal = [
  { mes: 'Jan', valor: 11000 },
  { mes: 'Fev', valor: 15500 },
  { mes: 'Mar', valor: 8900 },
  { mes: 'Abr', valor: 16800 },
  { mes: 'Mai', valor: 21500 },
  { mes: 'Jun', valor: 24000 },
];

const categorias = [
  { nome: 'Componentes', valor: 25800 },
  { nome: 'Rede', valor: 17600 },
  { nome: 'Armazenamento', valor: 16800 },
  { nome: 'Acessórios', valor: 12800 },
  { nome: 'Periféricos', valor: 11400 },
];

const statusPedidos = [
  { nome: 'Entregue', valor: 64.1 },
  { nome: 'Enviado', valor: 14.1 },
  { nome: 'Em processamento', valor: 10.9 },
  { nome: 'Pendente', valor: 5.5 },
  { nome: 'Cancelado', valor: 5.5 },
];

const cancelamentos = [
  { motivo: 'Produto indisponível', quantidade: 4 },
  { motivo: 'Falha na aprovação do pedido', quantidade: 4 },
  { motivo: 'Falta de estoque', quantidade: 3 },
  { motivo: 'Erro de endereço', quantidade: 1 },
];

function Barra({ valor, maximo }) {
  const largura = `${Math.max((valor / maximo) * 100, 8)}%`;

  return (
    <div className="dashboard-barra-base">
      <div className="dashboard-barra" style={{ width: largura }} />
    </div>
  );
}

export default function Dashboard() {
  const tipo = localStorage.getItem('tipo');
  const nome = localStorage.getItem('nome');

  function handleLogout() {
    localStorage.clear();
    window.location.hash = '#login';
  }

  const maiorReceita = Math.max(...receitaMensal.map((item) => item.valor));
  const maiorCategoria = Math.max(...categorias.map((item) => item.valor));
  const maiorCancelamento = Math.max(...cancelamentos.map((item) => item.quantidade));

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
        <section className="card">
          <h2>Bem-vindo{nome ? `, ${nome}` : ''}</h2>
          <p>
            {tipo === 'ADMIN' || tipo === 'COLABORADOR'
              ? 'Dashboard gerencial para acompanhar indicadores do e-commerce e apoiar a tomada de decisão.'
              : 'Acesse seus pedidos ou nossa loja pelo menu ao lado.'}
          </p>
        </section>

        <section className="dashboard-grid">
          {resumo.map((item) => (
            <div className="dashboard-card" key={item.titulo}>
              <span>{item.titulo}</span>
              <strong>{item.valor}</strong>
              <small>{item.descricao}</small>
            </div>
          ))}
        </section>

        <section className="dashboard-charts">
          <div className="card">
            <h3>Receita por mês</h3>
            <p className="dashboard-subtitle">Mostra a evolução do faturamento ao longo do período.</p>
            {receitaMensal.map((item) => (
              <div className="dashboard-row" key={item.mes}>
                <span>{item.mes}</span>
                <Barra valor={item.valor} maximo={maiorReceita} />
                <strong>R$ {item.valor.toLocaleString('pt-BR')}</strong>
              </div>
            ))}
          </div>

          <div className="card">
            <h3>Faturamento por categoria</h3>
            <p className="dashboard-subtitle">Ajuda a identificar quais categorias geram mais receita.</p>
            {categorias.map((item) => (
              <div className="dashboard-row" key={item.nome}>
                <span>{item.nome}</span>
                <Barra valor={item.valor} maximo={maiorCategoria} />
                <strong>R$ {item.valor.toLocaleString('pt-BR')}</strong>
              </div>
            ))}
          </div>

          <div className="card">
            <h3>Status dos pedidos</h3>
            <p className="dashboard-subtitle">Permite acompanhar o andamento geral dos pedidos.</p>
            {statusPedidos.map((item) => (
              <div className="dashboard-row" key={item.nome}>
                <span>{item.nome}</span>
                <Barra valor={item.valor} maximo={100} />
                <strong>{item.valor}%</strong>
              </div>
            ))}
          </div>

          <div className="card">
            <h3>Motivos de cancelamento</h3>
            <p className="dashboard-subtitle">Indica onde a empresa deve priorizar melhorias.</p>
            {cancelamentos.map((item) => (
              <div className="dashboard-row" key={item.motivo}>
                <span>{item.motivo}</span>
                <Barra valor={item.quantidade} maximo={maiorCancelamento} />
                <strong>{item.quantidade}</strong>
              </div>
            ))}
          </div>
        </section>
      </main>
    </div>
  );
}