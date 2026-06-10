const API_URL = 'http://localhost:8080/pedidos';

document.getElementById('form-pedido').addEventListener('submit', async (e) => {
    e.preventDefault();

    const dto = {
        clienteId: parseInt(document.getElementById('clienteId').value)
    };

    try {
        const response = await apiFetch(API_URL, {
            method:  'POST',
            body:    JSON.stringify(dto)
        });

        const texto = await response.text();
        document.getElementById('output').textContent = texto;

        if (response.ok) {
            alert('Pedido criado com sucesso! Acesse "Itens do Pedido" para adicionar produtos.');
            document.getElementById('form-pedido').reset();
        }

    } catch (error) {
        console.error(error);
        document.getElementById('output').textContent = 'Erro ao conectar com a API';
    }
});
