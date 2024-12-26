# Beego Cat API

 ## Table of Contents
  
  1. [Project Overview](#project-overview)
  2. [Features](#features)
  3. [Project Structure](#project-structure)
  4. [Getting Started](#getting-started)
     - [Technology](#technology)
     - [Installation](#installation)
  5. [Testing](#testing)
  6. [Key Features Implementation](#key-features-implementation)

## Project Overview

This project is a web application that interacts with [TheCatAPI](https://thecatapi.com) to display random cat images, allow users to vote on them, mark them as favourites, and search for specific breeds. The backend is powered by Beego (Go framework), while the frontend utilizes JavaScript to manage user interactions and display dynamic content. The application is designed to call the Cat API asynchronously and display the images to the user and do other functionality in a seamless manner.

## Features

- **Display Cat Image**: Displays random cat images from TheCatAPI.
- **Voting**: Users can vote on cat images as "like" (upvote) or "dislike" (downvote).
- **Favouriting**: Users can add cat images to their favourites and view all their favourites.
- **Breeds**: Users can search for specific cat breeds, view images of that breed and read detailed information about the breed.
- **Dynamic Interaction**: The page updates with new cat images and information without requiring a full page reload.
- **Asynchronous API Calls**: Utilizes Go channels for handling asynchronous API calls to TheCatAPI.
  


## Project Structure
  
  ```plaintext
    cat-api/
      ├── conf/
      │   └── app.conf
      ├── controllers/
      │   └── cat_controller.go
      ├── routers/
      │   └── router.go
      ├── static/
      │   ├── css/
      │   │   ├── cat_breed_info.css
      │   │   ├── cat_image.css
      │   │   └── favorites.css
      │   └── js/
      │       ├── cat_breed_info.js
      │       ├── cat_image.js
      │       └── favorites.js
      ├── tests/
      │   └── default_test.go
      ├── views/
      │   ├── cat_breed_info.tpl
      │   ├── cat_image.tpl
      │   └── favorites.tpl
      ├── go.mod
      ├── go.sum
      ├── main.go
      └── README.md            
  ```




## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed on your system:

- Go (version 1.16 or later)
- Git
- Beego


### Technology
- **Backend**: Beego (Go framework)
- **Frontend**: HTML, CSS and Vanilla JavaScript
- **API**: [TheCatAPI](https://thecatapi.com)
- **Unit Testing**: Go testing framework


### Installation

   1. Install Go

      If you haven't installed Go, follow these steps:

      1. Visit the official Go downloads page: https://golang.org/dl/

      2. Download the appropriate installer for your operating system.

      3. Follow the installation instructions for your OS:
         - Windows: Run the MSI installer and follow the prompts.
         - macOS: Open the package file and follow the prompts.
         - Linux: Extract the archive to `/usr/local`:
         ```bash
         tar -C /usr/local -xzf go1.x.x.linux-amd64.tar.gz
         ```
      4. Add Go to your PATH:
         - For bash, add the following to your `~/.bashrc` or `~/.bash_profile`:
         ```
         export PATH=$PATH:/usr/local/go/bin
         export GOPATH=$HOME/go
         export PATH=$PATH:$GOPATH/bin
         ```
         - For other shells, add the equivalent to your shell's configuration file.

      5. Verify the installation by opening a new terminal and running:
         ```
         go version
         ```
  2. Install Beego

      If you haven't installed Beego, follow these steps:

      ```bash
      go install github.com/beego/bee/v2@latest
      ```
      For Linux:
      ```bash
      echo "export PATH=\$PATH:\$(go env GOPATH)/bin" >> ~/.bashrc
      source ~/.bashrc
      ```
      Verify the installation by opening a new terminal and running:

      ```bash
      bee version
      ```
      
   3. make directory

      ```bash
      mkdir -p ~/go/src/        "Windows===> mkdir C:\Users\Your_User_Name\go\src\"

      cd ~/go/src/              "Windows===> cd C:\Users\Your_User_Name\go\src\"
      ```


  1. Clone the repository:
     ```bash
     git clone https://github.com/Shazid18/Beego_Cat_API.git
     ```
     ```bash
     cd Beego_Cat_API.git
     ```
     ```bash
     cd cat-api
     ```
  
  2. Install dependencies:
     ```bash
     go mod tidy
     ```
     
  3. Configuration:
    **API Key**: Set your API key for TheCatAPI in the `conf/app.conf` file with the API key you obtained from The Cat API.
     ```bash
     CatAPIKey = "your-api-key-here"
     ```
  4. Run the Application:
    To run the Beego server, use the following command:
     ```bash
     go mod tidy
     bee run
     ```
     This will start the server, and you should be able to access the web application by visiting http://localhost:8080 in your browser.
     

## Testing
- To run the unit tests, use the following command:
   ```bash
   go test -v ./...
   ```
   
- To check test coverage, use the following command:

   ```bash
   go test -coverprofile=coverage.out ./...
   ```
   This will generate a coverage.out file containing the coverage data.
   
- To view the test coverage report, run:

   ```bash
   go tool cover -html=coverage.out
   ```
   This will open the coverage report in your default browser, showing the percentage of code covered by tests.
   
   
## Key Features Implementation

### 1. Voting on Images
The application allows users to vote on cat images (like or dislike). When a user clicks the "Like" or "Dislike" button, the following `POST` request is made to TheCatAPI to register the vote:

#### API Request for Voting
```json
{
  "image_id": "image-id-of-current-cat",
  "sub_id": "user-12345",  // Unique user ID
  "value": 1  // 1 for like, -1 for dislike
}
```
The backend will send a `POST` request to https://api.thecatapi.com/v1/votes.

### 2. Favouriting Images
Users can click the "Favourite" button to save the current cat image to their favourites. The following `POST` request is made to add the image to the user's favourites:

#### API Request for Favouriting
```json
{
  "image_id": "image-id-of-current-cat",
  "sub_id": "user-12345"
}
```
The backend will send a `POST` request to https://api.thecatapi.com/v1/favourites to save the image.

#### View All Favourites
When the user clicks on the "Fav" button in the navbar, a `GET` request is made to retrieve all the user's favourited cat images.
The backend will send a `GET` request to https://api.thecatapi.com/v1/favourites to retrieve all the images.

#### Deleting a Favourite
To delete a favourite image, a `DELETE` request is made to remove the image from the user's favourites by favouriteId.
The backend will send a `DELETE` request to DELETE https://api.thecatapi.com/v1/favourites/:favouriteId to delete that selected image.


### 3. Searching for Breeds
When the user clicks the "Breeds" button, a `GET` request is made to retrieve all the cat breeds. A search bar will suggest available breeds and allow users to select a specific breed. Upon selecting a breed, the following details will be shown:
- A slideshow of images of that breed.
- A description of the breed.
- A Wikipedia link for more information.

The backend will send a `GET` request to https://api.thecatapi.com/v1/breeds to get all the available breeds.