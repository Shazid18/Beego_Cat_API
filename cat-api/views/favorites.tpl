<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Favorite Cats</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin: 20px; }
        .favorites-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            padding: 20px;
        }
        .favorite-item {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 10px;
        }
        .favorite-item img {
            max-width: 100%;
            height: auto;
            border-radius: 4px;
        }
        .delete-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        }
        .message {
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            display: none;
        }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <div class="nav-bar">
        <button class="nav-button" onclick="window.location.href='/cats/random'">Voting</button>
        <button class="nav-button" onclick="window.location.href='/cats/breedinfo'">Breeds</button>
        <button class="nav-button" onclick="window.location.href='/cats/favorites'">Favs</button>
    </div>

    <h1>My Favorite Cats</h1>
    <div id="message" class="message"></div>

    {{if .error}}
        <p style="color: red;">{{.error}}</p>
    {{else}}
        <div class="favorites-grid">
            {{range .Favorites}}
                <div class="favorite-item" id="favorite-{{.ID}}">
                    <img src="{{.Image.URL}}" alt="Favorite Cat">
                    <button class="delete-btn" onclick="deleteFavorite({{.ID}})">Remove from Favorites</button>
                </div>
            {{end}}
        </div>
    {{end}}

    <script>
        function showMessage(text, isError = false) {
            const messageDiv = document.getElementById('message');
            messageDiv.textContent = text;
            messageDiv.className = `message ${isError ? 'error' : 'success'}`;
            messageDiv.style.display = 'block';
            setTimeout(() => {
                messageDiv.style.display = 'none';
            }, 3000);
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
                    showMessage('Favorite removed successfully');
                }
            } catch (error) {
                showMessage('Failed to delete favorite', true);
            }
        }
    </script>
</body>
</html>