<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cat Features</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { 
            font-family: Arial, sans-serif; 
            text-align: center; 
            margin: 20px; 
            background-color: #f5f5f5;
        }
        .image-container {
            position: relative;
            width: 600px;
            height: 600px;
            margin: 20px auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .cat-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 4px;
        }
        .button-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            padding: 0 20px;
        }
        .left-buttons, .right-buttons {
            display: flex;
            gap: 10px;
        }
        .button {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            transition: transform 0.2s, background-color 0.2s;
        }
        .button:hover {
            transform: scale(1.1);
        }
        .favorite-btn {
            background-color: #ff4081;
            color: white;
        }
        .favorite-btn:hover {
            background-color: #f50057;
        }
        .vote-up {
            background-color: #28a745;
            color: white;
        }
        .vote-up:hover {
            background-color: #218838;
        }
        .vote-down {
            background-color: #dc3545;
            color: white;
        }
        .vote-down:hover {
            background-color: #c82333;
        }
        .message { 
            padding: 10px; 
            margin: 10px 0; 
            border-radius: 5px; 
            display: none; 
        }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
        .nav-bar {
            background-color: #fff;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .nav-button {
            padding: 10px 15px;
            margin: 0 5px;
            cursor: pointer;
            text-decoration: none;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
        }
        .nav-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="nav-bar">
        <button class="nav-button" onclick="window.location.href='/cats/random'">Voting</button>
        <button class="nav-button" onclick="window.location.href='/cats/breedinfo'">Breeds</button>
        <button class="nav-button" onclick="window.location.href='/cats/favorites'">Favs</button>
    </div>

    <div id="message" class="message"></div>

    {{if .error}}
        <p style="color: red;">{{.error}}</p>
    {{else if .CatImage}}
        <div class="image-container">
            <img src="{{.CatImage.URL}}" alt="Random Cat" class="cat-image" id="catImage">
            <div class="button-container">
                <div class="left-buttons">
                    <button class="button favorite-btn" onclick="addToFavorites()">
                        <i class="fas fa-heart"></i>
                    </button>
                </div>
                <div class="right-buttons">
                    <button class="button vote-up" onclick="vote('{{.CatImage.ID}}', 1)">
                        <i class="fas fa-thumbs-up"></i>
                    </button>
                    <button class="button vote-down" onclick="vote('{{.CatImage.ID}}', -1)">
                        <i class="fas fa-thumbs-down"></i>
                    </button>
                </div>
            </div>
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

            // Just add the following function for favorites
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