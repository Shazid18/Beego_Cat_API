<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cat Breeds</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin: 20px; }
        .button { padding: 10px 20px; margin: 5px; cursor: pointer; }
        .nav-button { padding: 10px 15px; margin: 0 5px; cursor: pointer; text-decoration: none; background-color: #007BFF; color: white; border: none; border-radius: 5px; }
        .nav-button:hover { background-color: #0056b3; }
    </style>
</head>
<body>
    <div class="nav-bar">
        <button class="nav-button" onclick="window.location.href='/cats/random'">Voting</button>
        <button class="nav-button" onclick="window.location.href='/cats/breeds'">Breeds</button>
        <button class="nav-button" onclick="window.location.href='/cats/favorites'">Favs</button>
    </div>

    <h1>Select a Cat Breed</h1>

    {{if .error}}
        <p style="color: red;">{{.error}}</p>
    {{else}}
        <form method="GET" action="/cats/breedinfo">
            <label for="breed">Select Breed: </label>
            <select name="breed" id="breed">
                {{range .Breeds}}
                    <option value="{{.}}">{{.}}</option>
                {{end}}
            </select>
            <button class="button" type="submit">Show Breed</button>
        </form>
    {{end}}
</body>
</html>
