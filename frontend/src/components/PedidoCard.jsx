import { useState } from 'react';
import { apiFetch, formatarMoeda, formatarDataHora } from '../utils/api';

export default function PedidoCard({ pedido, itensUrl }) {
  const [aberto, setAberto] = useState(false);
  const [itens, setItens] = useState([]);
  const [carregado, setCarregado] = useState(false);

  async function toggleItens() {
    if (!aberto && !carregado) {
      const response = await apiFetch(itensUrl(pedido.pedidoId));
      if (response && response.ok) {
        const data = await response.json();
        setItens(data);
        setCarregado(true);
      }
    }
    setAberto((v) => !v);
  }

  return (
    <div className="record-card">
      <h3>Pedido #{pedido.pedidoId} — {pedido.status}</h3>
      {[['Cliente', pedido.clienteId], ['Data', formatarDataHora(pedido.data)], ['Status', pedido.status]].map(([l, v]) => (
        <div key={l} className="record-row">
          <span className="record-label">{l}:</span>
          <span className="record-value">{v ?? '-'}</span>
        </div>
      ))}

      <button type="button" className="small-button" style={{ marginTop: '0.5rem' }} onClick={toggleItens}>
        {aberto ? 'Ocultar Itens' : 'Ver Itens'}
      </button>

      {aberto && (
        <div style={{ marginTop: '0.5rem' }}>
          {itens.length === 0
            ? <p className="empty-state" style={{ fontSize: '.85rem' }}>Nenhum item neste pedido.</p>
            : (
              <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '.85rem' }}>
                <thead>
                  <tr>
                    {['Produto', 'ID', 'Qtd', 'Valor Pago'].map((h) => (
                      <th key={h} style={{ textAlign: 'left', padding: '4px 8px', borderBottom: '1px solid #ccc' }}>{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {itens.map((item) => (
                    <tr key={item.produtoId}>
                      <td style={{ padding: '4px 8px' }}>{item.nome}</td>
                      <td style={{ padding: '4px 8px' }}>#{item.produtoId}</td>
                      <td style={{ padding: '4px 8px' }}>{item.quantidade}</td>
                      <td style={{ padding: '4px 8px' }}>{formatarMoeda(item.valorPago)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
        </div>
      )}
    </div>
  );
}
