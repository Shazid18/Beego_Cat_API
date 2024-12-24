<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.BreedInfo.Name}} - Cat Breed Info</title>
    <link rel="stylesheet" href="/static/css/cat_breed_info.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="page-container">
        <nav class="nav-bar">
            <a href="/" class="nav-item">
                <i class="fas fa-up-down"></i>
                Voting
            </a>
            <a href="/cats/breedinfo" class="nav-item active">
                <i class="fas fa-search"></i>
                Breeds
            </a>
            <a href="/cats/favorites" class="nav-item">
                <i class="far fa-heart"></i>
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

    <script src="/static/js/cat_breed_info.js"></script>
</body>
</html>
