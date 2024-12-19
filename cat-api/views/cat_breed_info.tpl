<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{.BreedInfo.Name}} - Cat Breed Info</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin: 20px; display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 100vh; }
        .button { padding: 10px 20px; margin: 5px; cursor: pointer; }
        .nav-button { padding: 10px 15px; margin: 0 5px; cursor: pointer; text-decoration: none; background-color: #007BFF; color: white; border: none; border-radius: 5px; }
        .nav-button:hover { background-color: #0056b3; }
        
        /* Center the slideshow */
        .slideshow { 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            margin-bottom: 20px; 
            width: 100%;
            max-width: 600px; /* Set a maximum width for the slideshow */
            overflow: hidden;
        }

        /* Fixed width and height for images */
        .slideshow img {
            width: 500px; /* Fixed width */
            height: 300px; /* Fixed height */
            object-fit: cover; /* Ensures aspect ratio is preserved */
            margin: 20px 0;
            display: none;
            border-radius: 8px; /* Optional: Adds rounded corners */
        }

        .dots { text-align: center; padding: 10px 0; }
        .dot { height: 15px; width: 15px; margin: 0 5px; background-color: #bbb; border-radius: 50%; display: inline-block; cursor: pointer; transition: background-color 0.3s; }
        .dot.active { background-color: #717171; }

        /* Styling for BreedInfo and other sections */
        .info-section {
            display: flex;
            gap: 20px; /* Space between the text elements */
            margin-top: 20px;
            font-size: 16px; /* Adjust font size */
            text-align: left; /* Left-align the content */
            width: 100%; /* Ensures that the content takes full width */
            max-width: 600px; /* Limit the width if necessary */
            margin-left: auto;
            margin-right: auto;
        }

        .info-section span {
            display: inline-block;
        }

        .breed-name {
            font-weight: bold;
            color: black;
        }

        .breed-origin {
            font-weight: bold;
            color: gray;
        }

        .breed-origin::before {
            content: "(";
            font-weight: normal;
        }

        .breed-origin::after {
            content: ")";
            font-weight: normal;
        }

        .breed-id {
            color: gray;
        }

        .description, .wikipedia {
            margin-top: 20px;
            text-align: left; /* Left-align the Description and Wikipedia sections */
            width: 100%;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .description p, .wikipedia p {
            font-size: 16px;
            line-height: 1.5;
        }

        /* Change Wikipedia text to be a clickable orange text */
        .wikipedia a {
            color: orange; /* Set the text color to orange */
            text-decoration: none; /* Remove underline */
            font-weight: bold; /* Make the link bold */
        }

        .wikipedia a:hover {
            text-decoration: underline; /* Optional: Adds underline on hover */
        }
    </style>
</head>
<body>
    <div class="nav-bar">
        <button class="nav-button" onclick="window.location.href='/cats/random'">Voting</button>
        <button class="nav-button" onclick="window.location.href='/cats/breeds'">Breeds</button>
        <button class="nav-button" onclick="window.location.href='/cats/favorites'">Favs</button>
    </div>


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

    <!-- Breed Info Section in Same Line, Left Aligned -->
    <div class="info-section">
        <span class="breed-name">{{.BreedInfo.Name}}</span>
        <span class="breed-origin">{{.BreedInfo.Origin}}</span>
        <span class="breed-id">{{.BreedInfo.ID}}</span>
    </div>

    <!-- Description Section, Left Aligned -->
    <div class="description">
        <p><strong>Description:</strong> {{.BreedInfo.Info}}</p>
    </div>

    <!-- Wikipedia Section with "WIKIPEDIA" text as a link -->
    <div class="wikipedia">
        <p><strong></strong> <a href="{{.BreedInfo.Wikipedia}}" target="_blank">WIKIPEDIA</a></p>
    </div>

    <script>
        // JavaScript for slideshow functionality
        let currentIndex = 0;
        const images = document.querySelectorAll('.slideshow img');
        const dots = document.querySelectorAll('.dot');

        function showImage(index) {
            // Hide all images
            images.forEach((img, i) => {
                img.style.display = 'none';
                dots[i].classList.remove('active');
            });

            // Show the current image
            images[index].style.display = 'block';
            dots[index].classList.add('active');
        }

        // Automatically change image every 3 seconds
        setInterval(() => {
            currentIndex = (currentIndex + 1) % images.length;
            showImage(currentIndex);
        }, 3000);

        // Dot click functionality to change image
        dots.forEach((dot, index) => {
            dot.addEventListener('click', () => {
                currentIndex = index;
                showImage(currentIndex);
            });
        });

        // Show the first image on page load
        showImage(currentIndex);
    </script>
</body>
</html>
