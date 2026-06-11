export default function CrudNavbar({ title, links }) {
  return (
    <header className="topbar">
      <div className="brand">{title}</div>
      <nav className="crud-navbar">
        <div className="crud-links">
          {links.map(({ label, page }) => (
            <a key={page} href={`#${page}`}>{label}</a>
          ))}
        </div>
      </nav>
    </header>
  );
}
