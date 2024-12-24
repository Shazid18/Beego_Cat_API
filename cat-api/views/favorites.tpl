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
            margin: 0;
            padding: 20px;
            background-color: white;
        }
        .page-container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .nav-bar {
            display: flex;
            gap: 30px;
            padding: 10px 0;
            margin-bottom: 15px;
        }
        .nav-item {
            text-decoration: none;
            color: #6b7280;
            font-size: 14px;
            font-weight: bold;
            display: flex;
            flex-direction: column; /* Stack the icon and text vertically */
            gap: 8px;
            align-items: center;
        }
        .nav-item i {
            font-size: 24px; /* Increase icon size */
        }
        .nav-item:hover {
            color: #f76842;
        }
        .nav-item.active {
            color: #f76842;
        }
        .view-controls {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
        }
        .view-controls i {
            font-size: 21px; /* Increase icon size */
        }
        .view-btn {
            background: none;
            border: none;
            color: #666;
            cursor: pointer;
            font-size: 18px;
            padding: 5px;
        }
        .view-btn.active {
            color: #f76842;
        }
        .favorites-wrapper {
            background: white;
            border-radius: 8px;
            height: 700px; /* Fixed height for the image container */
            width: 100%;  /* Full width of the page-container */
            overflow: hidden;
            margin-bottom: 15px;
        }
        .favorites-container {
            height: 100%;
            overflow-y: auto;
            padding: 10px;
        }
        /* Custom scrollbar */
        .favorites-container::-webkit-scrollbar {
            width: 8px;
        }
        .favorites-container::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        .favorites-container::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 4px;
        }
        .favorites-container::-webkit-scrollbar-thumb:hover {
            background: #555;
        }
        .grid-view {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            padding-right: 10px;
        }
        .list-view {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .favorite-item {
            position: relative;
            width: 100%;
            padding-bottom: 100%;
        }
        .favorite-item img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .delete-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background: none;
            border: none;
            color: white;
            cursor: pointer;
            z-index: 2;
            font-size: 18px;
            padding: 5px;
            text-shadow: 0 0 3px rgba(0,0,0,0.5);
        }
        .delete-btn:hover {
            color: #FF4081;
        }
        .message {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            padding: 10px 20px;
            border-radius: 20px;
            display: none;
        }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <div class="page-container">
        <nav class="nav-bar">
            <a href="/" class="nav-item">
                <i class="fas fa-up-down"></i>
                Voting
            </a>
            <a href="/cats/breedinfo" class="nav-item">
                <i class="fas fa-search"></i>
                Breeds
            </a>
            <a href="/cats/favorites" class="nav-item active">
                <i class="far fa-heart"></i>
                Favs
            </a>
        </nav>

        <div class="view-controls">
            <button class="view-btn active" onclick="toggleView('grid')">
                <i class="fas fa-th"></i>
            </button>
            <button class="view-btn" onclick="toggleView('list')">
                <i class="fas fa-bars"></i>
            </button>
        </div>

        <div id="message" class="message"></div>

        {{if .error}}
            <p style="color: red;">{{.error}}</p>
        {{else}}
            <div class="favorites-wrapper">
                <div id="favorites-container" class="favorites-container grid-view">
                    {{range .Favorites}}
                        <div class="favorite-item" id="favorite-{{.ID}}">
                            <img src="{{.Image.URL}}" alt="Favorite Cat">
                            <button class="delete-btn" onclick="deleteFavorite({{.ID}})">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    {{end}}
                </div>
            </div>
        {{end}}
    </div>

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
    </script>
</body>
</html>