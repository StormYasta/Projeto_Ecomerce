import Login from './pages/Login';
import Dashboard from './pages/Dashboard';

import ClienteCadastrar from './pages/Cliente/Cadastrar';
import ClienteEditar from './pages/Cliente/Editar';
import ClienteVisualizar from './pages/Cliente/Visualizar';

import ColaboradorCadastrar from './pages/Colaborador/Cadastrar';
import ColaboradorEditar from './pages/Colaborador/Editar';
import ColaboradorVisualizar from './pages/Colaborador/Visualizar';

import FornecedorCadastrar from './pages/Fornecedor/Cadastrar';
import FornecedorEditar from './pages/Fornecedor/Editar';
import FornecedorVisualizar from './pages/Fornecedor/Visualizar';

import ProdutoCadastrar from './pages/Produto/Cadastrar';
import ProdutoEditar from './pages/Produto/Editar';
import ProdutoVisualizar from './pages/Produto/Visualizar';

import PedidoCadastrar from './pages/Pedido/Cadastrar';
import PedidoItens from './pages/Pedido/Itens';
import PedidoStatus from './pages/Pedido/Status';
import PedidoVisualizar from './pages/Pedido/Visualizar';

import MeusPedidos from './pages/MeusPedidos/Visualizar';
import LojaVisualizar from './pages/Loja/Visualizar';

const ROUTES = {
  'login':                    Login,
  'dashboard':                Dashboard,
  'cliente/cadastrar':        ClienteCadastrar,
  'cliente/editar':           ClienteEditar,
  'cliente/visualizar':       ClienteVisualizar,
  'colaborador/cadastrar':    ColaboradorCadastrar,
  'colaborador/editar':       ColaboradorEditar,
  'colaborador/visualizar':   ColaboradorVisualizar,
  'fornecedor/cadastrar':     FornecedorCadastrar,
  'fornecedor/editar':        FornecedorEditar,
  'fornecedor/visualizar':    FornecedorVisualizar,
  'produto/cadastrar':        ProdutoCadastrar,
  'produto/editar':           ProdutoEditar,
  'produto/visualizar':       ProdutoVisualizar,
  'pedido/cadastrar':         PedidoCadastrar,
  'pedido/itens':             PedidoItens,
  'pedido/status':            PedidoStatus,
  'pedido/visualizar':        PedidoVisualizar,
  'meuspedidos/visualizar':   MeusPedidos,
  'loja/visualizar':          LojaVisualizar,
};

export default ROUTES;
