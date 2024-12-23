<!-- cat_image.tpl -->
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
        .vote-button { padding: 10px 20px; margin: 5px; cursor: pointer; border: none; border-radius: 5px; }
        .vote-up { background-color: #28a745; color: white; }
        .vote-down { background-color: #dc3545; color: white; }
        .message { padding: 10px; margin: 10px 0; border-radius: 5px; display: none; }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <div class="nav-bar">
        <button class="nav-button" onclick="window.location.href='/cats/random'">Voting</button>
        <button class="nav-button" onclick="window.location.href='/cats/breedinfo'">Breeds</button>
        <button class="nav-button" onclick="window.location.href='/cats/favorites'">Favs</button>
    </div>

    <h1>Random Cat Image</h1>
    <div id="message" class="message"></div>

    {{if .error}}
        <p style="color: red;">{{.error}}</p>
    {{else if .CatImage}}
        <img src="{{.CatImage.URL}}" alt="Random Cat" id="catImage">
        <div>
            <button class="vote-button vote-up" onclick="vote('{{.CatImage.ID}}', 1)">👍 Vote Up</button>
            <button class="vote-button vote-down" onclick="vote('{{.CatImage.ID}}', -1)">👎 Vote Down</button>
            <button class="button" onclick="addToFavorites()">Favorite</button>
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

            async function vote(imageId, value) {
                try {
                    const response = await fetch('/cats/vote', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            image_id: imageId,
                            sub_id: 'user-12345',
                            value: value
                        })
                    });

                    const result = await response.json();
                    if (result.error) {
                        showMessage(result.error, true);
                    } else {
                        showMessage(`Vote ${value > 0 ? 'up' : 'down'} recorded successfully!`);
                        setTimeout(() => {
                            window.location.reload();
                        }, 0);
                    }
                } catch (error) {
                    showMessage('Failed to submit vote', true);
                }
            }

            // Add this to the existing script section
            async function addToFavorites() {
                try {
                    const imageId = '{{.CatImage.ID}}';
                    const response = await fetch('/cats/favorites', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            image_id: imageId,
                            sub_id: 'user-12345'
                        })
                    });

                    const result = await response.json();
                    if (result.error) {
                        showMessage(result.error, true);
                    } else {
                        showMessage('Added to favorites successfully!');
                        setTimeout(() => {
                            window.location.reload();
                        }, 0);
                    }
                } catch (error) {
                    showMessage('Failed to add to favorites', true);
                }
            }
        </script>
    {{else}}
        <p>No image available. Try reloading the page.</p>
    {{end}}
</body>
</html>