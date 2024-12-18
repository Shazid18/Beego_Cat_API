<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cat Image Gallery</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        .gallery { display: flex; flex-wrap: wrap; gap: 10px; justify-content: center; }
        .cat-image { width: 200px; height: auto; border: 2px solid #ddd; border-radius: 10px; }
    </style>
</head>
<body>
    <h1>Cat Image Gallery</h1>
    <div class="gallery">
        {{range .CatImages}}
        <img class="cat-image" src="{{.URL}}" alt="Cat Image">
        {{end}}
    </div>
</body>
</html>
