<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Favorite Cats</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { 
            font-family: Arial, sans-serif; 
            text-align: center; 
            margin: 20px;
            background-color: #f5f5f5;
        }
        .view-controls {
            margin: 20px 0;
        }
        .view-btn {
            background-color: #007BFF;
            color: white;
            border: none;
            padding: 10px 20px;
            margin: 0 5px;
            border-radius: 4px;
            cursor: pointer;
        }
        .view-btn.active {
            background-color: #0056b3;
        }
        .favorites-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        /* Grid View Styles */
        .grid-view {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            padding: 20px;
        }
        /* List View Styles */
        .list-view {
            display: flex;
            flex-direction: column;
            gap: 20px;
            padding: 20px;
        }
        .list-view .favorite-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20px;
        }
        .list-view .favorite-item img {
            width: 200px;
            height: 200px;
            object-fit: cover;
            margin-right: 20px;
        }
        .favorite-item {
            background: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .favorite-item:hover {
            transform: translateY(-5px);
        }
        .favorite-item img {
            width: 300px;
            height: 300px;
            object-fit: cover;
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
            transition: background-color 0.2s;
        }
        .delete-btn:hover {
            background-color: #c82333;
        }
        .message {
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            display: none;
        }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
        .nav-bar {
            background-color: #fff;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .nav-button {
            padding: 10px 15px;
            margin: 0 5px;
            cursor: pointer;
            text-decoration: none;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            transition: background-color 0.2s;
        }
        .nav-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="nav-bar">
        <button class="nav-button" onclick="window.location.href='/cats/random'">Voting</button>
        <button class="nav-button" onclick="window.location.href='/cats/breedinfo'">Breeds</button>
        <button class="nav-button" onclick="window.location.href='/cats/favorites'">Favs</button>
    </div>

    <div class="view-controls">
        <button class="view-btn active" onclick="toggleView('grid')">
            <i class="fas fa-th"></i>
        </button>
        <button class="view-btn" onclick="toggleView('list')">
            <i class="fas fa-list"></i>
        </button>
    </div>
    <div id="message" class="message"></div>

    {{if .error}}
        <p style="color: red;">{{.error}}</p>
    {{else}}
        <div id="favorites-container" class="favorites-container grid-view">
            {{range .Favorites}}
                <div class="favorite-item" id="favorite-{{.ID}}">
                    <img src="{{.Image.URL}}" alt="Favorite Cat">
                    <button class="delete-btn" onclick="deleteFavorite({{.ID}})">
                        <i class="fas fa-trash"></i>
                    </button>
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

        function toggleView(viewType) {
            const container = document.getElementById('favorites-container');
            const buttons = document.querySelectorAll('.view-btn');
            
            // Update buttons
            buttons.forEach(btn => btn.classList.remove('active'));
            event.currentTarget.classList.add('active');
            
            // Update view
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
                    showMessage('Favorite removed successfully');
                }
            } catch (error) {
                showMessage('Failed to delete favorite', true);
            }
        }
    </script>
</body>
</html>