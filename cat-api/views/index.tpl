<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cat API Viewer</title>
    <link rel="stylesheet" href="/static/css/styles.css">
</head>
<body>
    <div class="nav-bar">
        <button class="nav-button" onclick="window.location.href='/cats/random'">Voting</button>
        <button class="nav-button" onclick="window.location.href='/cats/breedinfo'">Breeds</button>
        <button class="nav-button" onclick="window.location.href='/cats/favorites'">Favs</button>
    </div>
    <h1>Cat Image Gallery</h1>
    <button id="loadCats">Load Cats</button>
    <div id="catGallery" class="gallery"></div>

    <script src="/static/js/script.js"></script>
</body>
</html>
