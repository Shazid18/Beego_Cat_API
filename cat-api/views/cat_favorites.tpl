<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Favorite Cat Images</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin: 20px; }
        img { max-width: 100%; height: auto; margin: 10px 0; border: 2px solid #ddd; border-radius: 8px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-top: 20px; }
        .card { padding: 10px; border: 1px solid #ddd; border-radius: 8px; }
        h1 { margin-bottom: 20px; }
        a { text-decoration: none; color: #007BFF; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <h1>Your Favorite Cat Images</h1>
    <div>
        <a href="/cats/random">Get a Random Cat Image</a>
    </div>
    <div class="grid">
        {{if .FavoriteImages}}
            {{range .FavoriteImages}}
                <div class="card">
                    <img src="{{.URL}}" alt="Favorite Cat">
                </div>
            {{end}}
        {{else}}
            <p>You haven't added any favorites yet!</p>
        {{end}}
    </div>
</body>
</html>
