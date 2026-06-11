export default function RecordCard({ title, fields, children }) {
  return (
    <div className="record-card">
      {title && <h3>{title}</h3>}
      {Object.entries(fields).map(([label, value]) => (
        <div key={label} className="record-row">
          <span className="record-label">{label}:</span>
          <span className="record-value">
            {value === null || value === undefined || value === '' ? '-' : String(value)}
          </span>
        </div>
      ))}
      {children}
    </div>
  );
}
