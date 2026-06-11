import { useNav } from './hooks/useNav';
import ROUTES from './routes';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';

export default function App() {
  const { page, navigate } = useNav();

  const loggedIn = localStorage.getItem('loggedIn') === 'true';

  // Redireciona para login se não autenticado
  if (!loggedIn && page !== 'login') {
    navigate('login');
    return null;
  }

  // Login bem-sucedido
  if (page === 'login') {
    return <Login onLogin={() => navigate('dashboard')} />;
  }

  // Dashboard envolve as páginas com sidebar
  if (page === 'dashboard') {
    return (
      <>
        <header className="topbar">
          <span>{localStorage.getItem('tipo') === 'ADMIN' ? 'Painel Administrativo' : 'Minha Área'}</span>
          <span>{localStorage.getItem('nome') ?? ''}</span>
        </header>
        <Dashboard />
      </>
    );
  }

  const PageComponent = ROUTES[page];

  if (!PageComponent) {
    return (
      <div style={{ padding: '2rem' }}>
        <h2>Página não encontrada: {page}</h2>
        <a href="#dashboard">Voltar ao painel</a>
      </div>
    );
  }

  return <PageComponent />;
}
