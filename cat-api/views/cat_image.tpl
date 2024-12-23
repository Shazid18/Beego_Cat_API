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
            margin: 0;
            padding: 20px;
            background-color: white;
        }
        .page-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .nav-bar {
            display: flex;
            gap: 30px;
            padding: 10px 0;
            margin-bottom: 15px;
        }
        .nav-item {
            text-decoration: none;
            color: #666;
            font-size: 14px;
            display: flex;
            gap: 8px;
            align-items: center;
        }
        .nav-item:hover {
            color: #FF4081;
        }
        .nav-item.active {
            color: #FF4081;
        }
        .image-wrapper {
            background: white;
            border-radius: 8px;
            height: calc(100vh - 100px);
            overflow: hidden;
        }
        .image-container {
            height: 100%;
            overflow-y: auto;
            padding: 10px;
        }
        /* Custom scrollbar */
        .image-container::-webkit-scrollbar {
            width: 8px;
        }
        .image-container::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        .image-container::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 4px;
        }
        .image-container::-webkit-scrollbar-thumb:hover {
            background: #555;
        }
        .cat-image-box {
            position: relative;
            width: 100%;
            padding-bottom: 10px;
        }
        .cat-image {
            width: 100%;
            height: auto;
            display: block;
        }
        .button-container {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
        }
        .action-button {
            background: none;
            border: none;
            color: #666;
            cursor: pointer;
            font-size: 24px;
            padding: 5px;
        }
        .action-button:hover {
            color: #FF4081;
        }
        .message {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            padding: 10px 20px;
            border-radius: 20px;
            display: none;
        }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <div class="page-container">
        <nav class="nav-bar">
            <a href="/cats/random" class="nav-item active">
                <i class="fas fa-arrow-up-arrow-down"></i>
                Voting
            </a>
            <a href="/cats/breedinfo" class="nav-item">
                <i class="fas fa-search"></i>
                Breeds
            </a>
            <a href="/cats/favorites" class="nav-item">
                <i class="fas fa-heart"></i>
                Favs
            </a>
        </nav>

        <div id="message" class="message"></div>

        {{if .error}}
            <p style="color: red;">{{.error}}</p>
        {{else if .CatImage}}
            <div class="image-wrapper">
                <div class="image-container">
                    <div class="cat-image-box">
                        <img src="{{.CatImage.URL}}" alt="Random Cat" class="cat-image" id="catImage">
                        <div class="button-container">
                            <button class="action-button" onclick="addToFavorites()">
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
                    </div>
                </div>
            </div>
        {{else}}
            <p>No image available. Try reloading the page.</p>
        {{end}}
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
                    showMessage(`Vote recorded successfully!`);
                    setTimeout(() => {
                        window.location.reload();
                    }, 1500);
                }
            } catch (error) {
                showMessage('Failed to submit vote', true);
            }
        }

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
                    showMessage('Added to favorites!');
                    setTimeout(() => {
                        window.location.reload();
                    }, 1500);
                }
            } catch (error) {
                showMessage('Failed to add to favorites', true);
            }
        }
    </script>
</body>
</html>