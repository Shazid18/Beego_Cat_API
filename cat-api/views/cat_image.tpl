<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cat Features</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin: 20px; }
        img { max-width: 100%; height: auto; margin: 20px 0; }
        .button { padding: 10px 20px; margin: 5px; cursor: pointer; }
        .nav-bar { margin-bottom: 20px; }
        .nav-button { padding: 10px 15px; margin: 0 5px; cursor: pointer; text-decoration: none; background-color: #007BFF; color: white; border: none; border-radius: 5px; }
        .nav-button:hover { background-color: #0056b3; }
    </style>
</head>
<body>
    <div class="nav-bar">
        <button class="nav-button" onclick="window.location.href='/cats/random'">Voting</button>
        <button class="nav-button" onclick="window.location.href='/cats/breedinfo'">Breeds</button>
        <button class="nav-button" onclick="window.location.href='/cats/favorites'">Favs</button>
    </div>

    <h1>Random Cat Image</h1>

    {{if .error}}
        <p style="color: red;">{{.error}}</p>
    {{else if .CatImage}}
        <img src="{{.CatImage.URL}}" alt="Random Cat" id="catImage">
        <div>
            <button class="button" onclick="voteOnImage(1)">Like</button>
            <button class="button" onclick="voteOnImage(-1)">Dislike</button>
            <button class="button" onclick="addToFavorites()">Favorite</button>
        </div>
        <script>
            const catImage = {
                id: "{{.CatImage.ID}}",
                url: "{{.CatImage.URL}}"
            };

            function voteOnImage(value) {
                const payload = {
                    image_id: catImage.id,  // The correct image ID from the template
                    value: value,
                    sub_id: "demo-0.120221667167041654"  // Hardcoded sub_id for the user
                };

                fetch('/cats/vote', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(payload)
                })
                .then(response => response.json())
                .then(data => {
                    alert(data.message || data.error);  // Show success or error message
                    reloadImage(); // Refresh after voting
                })
                .catch(error => {
                    alert('Error voting: ' + error);
                });
            }

            function reloadImage() {
                window.location.reload();
            }
        </script>
    {{else}}
        <p>No image available. Try reloading the page.</p>
    {{end}}
</body>
</html>
