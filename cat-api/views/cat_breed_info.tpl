<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.BreedInfo.Name}} - Cat Breed Info</title>
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
        .breed-select {
            width: 100%;
            margin-bottom: 20px;
        }
        .breed-select select {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #eee;
            border-radius: 8px;
            color: #666;
        }
        .content-wrapper {
            background: white;
            border-radius: 8px;
            height: calc(100vh - 140px);
            overflow: hidden;
        }
        .content-container {
            height: 100%;
            overflow-y: auto;
            padding: 10px;
        }
        /* Custom scrollbar */
        .content-container::-webkit-scrollbar {
            width: 8px;
        }
        .content-container::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        .content-container::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 4px;
        }
        .content-container::-webkit-scrollbar-thumb:hover {
            background: #555;
        }
        .slideshow {
            width: 100%;
            position: relative;
            margin-bottom: 20px;
        }
        .slideshow img {
            width: 100%;
            height: auto;
            display: none;
            border-radius: 8px;
        }
        .dots {
            text-align: center;
            padding: 10px 0;
        }
        .dot {
            height: 8px;
            width: 8px;
            margin: 0 4px;
            background-color: #ddd;
            border-radius: 50%;
            display: inline-block;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .dot.active {
            background-color: #FF4081;
        }
        .info-section {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            align-items: center;
        }
        .breed-name {
            font-weight: bold;
            color: #333;
        }
        .breed-origin {
            color: #666;
            font-weight: 500;
        }
        .breed-id {
            color: #999;
            font-style: italic;
        }
        .description {
            margin-bottom: 20px;
            line-height: 1.6;
            color: #666;
        }
        .wikipedia {
            margin-top: 20px;
        }
        .wikipedia a {
            color: #FF4081;
            text-decoration: none;
            font-weight: 500;
        }
        .wikipedia a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="page-container">
        <nav class="nav-bar">
            <a href="/cats/random" class="nav-item">
                <i class="fas fa-arrow-up-arrow-down"></i>
                Voting
            </a>
            <a href="/cats/breedinfo" class="nav-item active">
                <i class="fas fa-search"></i>
                Breeds
            </a>
            <a href="/cats/favorites" class="nav-item">
                <i class="fas fa-heart"></i>
                Favs
            </a>
        </nav>

        <div class="breed-select">
            <select name="breed" onchange="window.location.href='/cats/breedinfo?breed=' + this.value">
                {{range .Breeds}}
                    <option value="{{.}}" {{if eq . $.SelectedBreed}}selected{{end}}>{{.}}</option>
                {{end}}
            </select>
        </div>

        <div class="content-wrapper">
            <div class="content-container">
                <div class="slideshow">
                    {{range .BreedInfo.ImageURLs}}
                        <img src="{{.}}" alt="Cat Image">
                    {{end}}
                </div>

                <div class="dots">
                    {{range .BreedInfo.ImageURLs}}
                        <span class="dot"></span>
                    {{end}}
                </div>

                <div class="info-section">
                    <span class="breed-name">{{.BreedInfo.Name}}</span>
                    <span class="breed-origin">({{.BreedInfo.Origin}})</span>
                    <span class="breed-id">{{.BreedInfo.ID}}</span>
                </div>

                <div class="description">
                    {{.BreedInfo.Info}}
                </div>

                <div class="wikipedia">
                    <a href="{{.BreedInfo.Wikipedia}}" target="_blank">WIKIPEDIA</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        let currentIndex = 0;
        const images = document.querySelectorAll('.slideshow img');
        const dots = document.querySelectorAll('.dot');

        function showImage(index) {
            images.forEach((img, i) => {
                img.style.display = 'none';
                dots[i].classList.remove('active');
            });

            images[index].style.display = 'block';
            dots[index].classList.add('active');
        }

        setInterval(() => {
            currentIndex = (currentIndex + 1) % images.length;
            showImage(currentIndex);
        }, 3000);

        dots.forEach((dot, index) => {
            dot.addEventListener('click', () => {
                currentIndex = index;
                showImage(currentIndex);
            });
        });

        showImage(currentIndex);
    </script>
</body>
</html>