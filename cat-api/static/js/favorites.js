function showMessage(text, isError = false) {
    const messageDiv = document.getElementById('message');
    messageDiv.textContent = text;
    messageDiv.className = `message ${isError ? 'error' : 'success'}`;
    messageDiv.style.display = 'block';
    setTimeout(() => {
        messageDiv.style.display = 'none';
    }, 3000);
}

function toggleView(viewType) {
    const container = document.getElementById('favorites-container');
    const buttons = document.querySelectorAll('.view-btn');
    
    buttons.forEach(btn => btn.classList.remove('active'));
    event.currentTarget.classList.add('active');
    
    container.className = `favorites-container ${viewType}-view`;
}

async function deleteFavorite(favoriteId) {
    try {
        const response = await fetch(`/cats/favorites/${favoriteId}`, {
            method: 'DELETE',
        });

        const result = await response.json();
        if (result.error) {
            showMessage(result.error, true);
        } else {
            const element = document.getElementById(`favorite-${favoriteId}`);
            element.remove();
            showMessage('Removed from favorites');
        }
    } catch (error) {
        showMessage('Failed to remove from favorites', true);
    }
}
