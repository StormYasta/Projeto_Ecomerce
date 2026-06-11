export default function SearchBar({ label, value, onChange, onSearch, extraButtons = [] }) {
  return (
    <section className="search-panel">
      <h2>Buscar {label}</h2>
      <div className="field-row">
        <label>ID {label && `do ${label}`}</label>
        <input
          type="number"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder={`Digite o ID`}
        />
      </div>
      <div style={{ display: 'flex', gap: '8px', marginTop: '1em', flexWrap: 'wrap' }}>
        <button type="button" className="small-button" onClick={onSearch}>
          Buscar
        </button>
        {extraButtons.map(({ label: btnLabel, onClick }) => (
          <button key={btnLabel} type="button" className="small-button" onClick={onClick}>
            {btnLabel}
          </button>
        ))}
      </div>
    </section>
  );
}
