function showMessage(text, isError = false) {
    const messageDiv = document.getElementById('message');
    messageDiv.textContent = text;
    messageDiv.className = `message ${isError ? 'error' : 'success'}`;
    messageDiv.style.display = 'block';
    setTimeout(() => {
        messageDiv.style.display = 'none';
    }, 3000);
}

async function vote(imageId, value) {
    try {
        const response = await fetch('/cats/vote', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                image_id: imageId,
                sub_id: 'user-12345',
                value: value
            })
        });

        const result = await response.json();
        if (result.error) {
            showMessage(result.error, true);
        } else {
            showMessage(`Vote recorded successfully!`);
            setTimeout(() => {
                window.location.reload();
            }, 10);
        }
    } catch (error) {
        showMessage('Failed to submit vote', true);
    }
}

async function addToFavorites(imageId) {
    try {
        const response = await fetch('/cats/favorites', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                image_id: imageId,
                sub_id: 'user-12345'
            })
        });

        const result = await response.json();
        if (result.error) {
            showMessage(result.error, true);
        } else {
            showMessage('Added to favorites!');
            setTimeout(() => {
                window.location.reload();
            }, 10);
        }
    } catch (error) {
        showMessage('Failed to add to favorites', true);
    }
}
