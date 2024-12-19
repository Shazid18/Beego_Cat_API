<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.BreedInfo.Name}} - Cat Breed Info</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin: 20px; }
        img { max-width: 100%; height: auto; margin: 20px 0; }
        .button { padding: 10px 20px; margin: 5px; cursor: pointer; }
        .nav-button { padding: 10px 15px; margin: 0 5px; cursor: pointer; text-decoration: none; background-color: #007BFF; color: white; border: none; border-radius: 5px; }
        .nav-button:hover { background-color: #0056b3; }
        .slideshow { display: flex; justify-content: center; overflow-x: auto; }
        .slideshow img { margin: 10px; max-height: 300px; }
    </style>
</head>
<body>
    <div class="nav-bar">
        <button class="nav-button" onclick="window.location.href='/cats/random'">Voting</button>
        <button class="nav-button" onclick="window.location.href='/cats/breeds'">Breeds</button>
        <button class="nav-button" onclick="window.location.href='/cats/favorites'">Favs</button>
    </div>

    <h1>{{.BreedInfo.Name}} Breed</h1>

    <div class="slideshow">
        {{range .BreedInfo.ImageURLs}}
            <img src="{{.}}" alt="Cat Image">
        {{end}}
    </div>

    <p><strong>Id:</strong> {{.BreedInfo.ID}}</p>
    <p><strong>Origin:</strong> {{.BreedInfo.Origin}}</p>
    <p><strong>Description:</strong> {{.BreedInfo.Info}}</p>
    <p><strong>Wikipedia:</strong> <a href="{{.BreedInfo.Wikipedia}}" target="_blank">{{.BreedInfo.Wikipedia}}</a></p>
</body>
</html>
