export default function OutputPanel({ text }) {
  return (
    <aside className="output-panel">
      <h3>Resultado</h3>
      <pre id="output">{text || 'Aguardando...'}</pre>
    </aside>
  );
}
