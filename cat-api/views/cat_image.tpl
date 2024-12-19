<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Random Cat Image</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin: 20px; }
        img { max-width: 100%; height: auto; margin: 20px 0; }
        .button { padding: 10px 20px; margin: 5px; cursor: pointer; }
    </style>
</head>
<body>
    <h1>Random Cat Image</h1>

    {{if .error}}
        <p style="color: red;">{{.error}}</p>
    {{else if .CatImage}}
        <img src="{{.CatImage.URL}}" alt="Random Cat" id="catImage">
        <div>
            <button class="button" onclick="reloadImage()">Like</button>
            <button class="button" onclick="reloadImage()">Dislike</button>
            <button class="button" onclick="addToFavorites()">Favorite</button>
        </div>
        <script>
            const catImage = {
                id: "{{.CatImage.ID}}",
                url: "{{.CatImage.URL}}"
            };

            function reloadImage() {
                window.location.reload();
            }

            function addToFavorites() {
                fetch('/cats/favorites', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(catImage)
                })
                .then(response => response.json()) // This will now correctly parse the JSON response
                .then(data => {
                    if (data.message) {
                        alert(data.message); // Show success message
                    } else if (data.error) {
                        alert('Error: ' + data.error); // Show error message
                    }
                    reloadImage(); // Reload the page after adding to favorites
                })
                .catch(error => alert('Error adding to favorites: ' + error.message));
            }
        </script>
    {{else}}
        <p>No image available. Try reloading the page.</p>
    {{end}}
</body>
</html>
