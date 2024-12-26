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
    beego-cat-api-viewer/
        ├── conf/
        │   └── app.conf          
        ├── controllers/
        │   └── main.go           
        ├── models/
        │   └── cat.go           
        ├── static/               
        │   └── js/
        │       └── app.js        
        ├── tests/
        │   └── main_test.go      
        ├── views/
        │   └── index.tpl         
        └── main.go               
  ```




## Getting Started


### Technology
- **Backend**: Beego (Go framework)
- **Frontend**: HTML, CSS and Vanilla JavaScript
- **API**: [TheCatAPI](https://thecatapi.com)
- **Unit Testing**: Go testing framework


### Installation
  
  1. Clone the repository:
     ```bash
     git clone https://github.com/Shazid18/beego-cat-api-viewer.git
     ```
     ```bash
     cd beego-cat-api-viewer
     ```
     ```bash
     cd beego-cat-api
     ```
  
  2. Install dependencies:
     ```bash
     go get github.com/beego/bee/v2@latest
     ```
     
  3. Configuration:
    **API Key**: Set your API key for TheCatAPI in the conf/app.conf file.
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