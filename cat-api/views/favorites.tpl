<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Favorite Cats</title>
    <link rel="stylesheet" href="/static/css/favorites.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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

    <script src="/static/js/favorites.js"></script>
</body>
</html>
