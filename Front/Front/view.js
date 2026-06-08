const viewContent = document.getElementById('view-content');
const viewOutput = document.getElementById('view-output');
const refreshButton = document.getElementById('refresh-data');
const clearButton = document.getElementById('clear-data');

refreshButton.addEventListener('click', renderView);
clearButton.addEventListener('click', clearStorage);

window.addEventListener('load', renderView);

function renderView() {
    const cadastros = JSON.parse(localStorage.getItem('cadastros') || '{}');
    viewContent.innerHTML = '';

    const entities = Object.keys(cadastros);
    if (entities.length === 0) {
        viewContent.innerHTML = '<p class="empty-state">Nenhum cadastro salvo ainda.</p>';
        viewOutput.textContent = 'Sem registros.';
        return;
    }

    let total = 0;
    entities.forEach(entity => {
        const records = cadastros[entity] || [];
        total += records.length;
        viewContent.appendChild(renderEntitySection(entity, records));
    });

    viewOutput.textContent = `Entidades exibidas: ${entities.length}\nTotal de registros: ${total}`;
}

function renderEntitySection(entity, records) {
    const section = document.createElement('div');
    section.className = 'view-section';

    const title = document.createElement('h3');
    title.textContent = `${entity.charAt(0).toUpperCase() + entity.slice(1)} (${records.length})`;
    section.appendChild(title);

    records.forEach(record => {
        const card = document.createElement('div');
        card.className = 'record-card';
        Object.keys(record).forEach(key => {
            const row = document.createElement('div');
            row.className = 'record-row';
            const label = document.createElement('span');
            label.className = 'record-label';
            label.textContent = `${formatKey(key)}:`;
            const value = document.createElement('span');
            value.className = 'record-value';
            value.textContent = formatValue(record[key]);
            row.appendChild(label);
            row.appendChild(value);
            card.appendChild(row);
        });
        section.appendChild(card);
    });

    return section;
}

function formatValue(value) {
    if (Array.isArray(value)) return value.join(', ');
    if (value === null || value === undefined || value === '') return '-';
    return value.toString();
}

function formatKey(key) {
    return key
        .replace(/([A-Z])/g, ' $1')
        .replace(/^./, str => str.toUpperCase());
}

function clearStorage() {
    localStorage.removeItem('cadastros');
    renderView();
}
