import { useState, useEffect } from 'react';

export function useNav() {
  const getPage = () => window.location.hash.replace('#', '') || 'dashboard';

  const [page, setPage] = useState(getPage);

  useEffect(() => {
    const handler = () => setPage(getPage());
    window.addEventListener('hashchange', handler);
    return () => window.removeEventListener('hashchange', handler);
  }, []);

  function navigate(p) {
    window.location.hash = `#${p}`;
  }

  return { page, navigate };
}
