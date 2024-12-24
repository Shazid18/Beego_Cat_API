<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cat Features</title>
    <link rel="stylesheet" href="static/css/cat_image.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="page-container">
        <nav class="nav-bar">
            <a href="/" class="nav-item active">
                <i class="fas fa-up-down"></i>
                Voting
            </a>
            <a href="/cats/breedinfo" class="nav-item">
                <i class="fas fa-search"></i>
                Breeds
            </a>
            <a href="/cats/favorites" class="nav-item">
                <i class="far fa-heart"></i>
                Favs
            </a>
        </nav>

        <div id="message" class="message"></div>

        {{if .error}}
            <p style="color: red;">{{.error}}</p>
        {{else if .CatImage}}
            <div class="image-wrapper">
                <img src="{{.CatImage.URL}}" alt="Random Cat" class="cat-image" id="catImage">
            </div>
            <div class="button-container">
                <button class="action-button" onclick="addToFavorites('{{.CatImage.ID}}')">
                    <i class="far fa-heart"></i>
                </button>
                <div>
                    <button class="action-button" onclick="vote('{{.CatImage.ID}}', 1)">
                        <i class="far fa-thumbs-up"></i>
                    </button>
                    <button class="action-button" onclick="vote('{{.CatImage.ID}}', -1)">
                        <i class="far fa-thumbs-down"></i>
                    </button>
                </div>
            </div>
        {{else}}
            <p>No image available. Try reloading the page.</p>
        {{end}}
    </div>

    <script src="static/js/cat_image.js"></script>
</body>
</html>
