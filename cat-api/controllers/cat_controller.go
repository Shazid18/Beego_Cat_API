
package controllers

import (
	"encoding/json"
	"net/http"
	"sync"
	"fmt"
	"github.com/beego/beego/v2/server/web"
)

// CatController handles requests related to cat images.
type CatController struct {
	web.Controller
}

type CatImage struct {
	ID  string `json:"id"`
	URL string `json:"url"`
}

// A thread-safe storage for favorite images.
var favoriteImages = struct {
	sync.Mutex
	Images []CatImage
}{}

// GetRandomCatImage fetches a random cat image from The Cat API and renders it on the page.
func (c *CatController) GetRandomCatImage() {
	apiKey := web.AppConfig.DefaultString("catapi.key", "")
	apiURL := "https://api.thecatapi.com/v1/images/search"

	client := &http.Client{}
	req, err := http.NewRequest("GET", apiURL, nil)
	if err != nil {
		c.Data["error"] = "Failed to create request"
		c.TplName = "cat_image.tpl"
		c.Render()
		return
	}
	req.Header.Set("x-api-key", apiKey)

	resp, err := client.Do(req)
	if err != nil {
		c.Data["error"] = "Failed to fetch image"
		c.TplName = "cat_image.tpl"
		c.Render()
		return
	}
	defer resp.Body.Close()

	var images []CatImage
	if err := json.NewDecoder(resp.Body).Decode(&images); err != nil {
		c.Data["error"] = "Failed to parse response"
		c.TplName = "cat_image.tpl"
		c.Render()
		return
	}

	if len(images) > 0 {
		c.Data["CatImage"] = images[0]
	} else {
		c.Data["error"] = "No image found"
	}
	c.TplName = "cat_image.tpl"
	c.Render()
}

// AddToFavorites adds the current cat image to the favorite list.
func (c *CatController) AddToFavorites() {
	var image CatImage
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &image); err != nil {
		// Return a JSON error response
		c.Data["json"] = map[string]string{"error": "Invalid data"}
		c.ServeJSON()
		return
	}

	// Add image to the favorites list
	favoriteImages.Lock()
	favoriteImages.Images = append(favoriteImages.Images, image)
	favoriteImages.Unlock()

	// Return a success response as JSON
	c.Data["json"] = map[string]string{"message": "Image added to favorites"}
	c.ServeJSON()
}
// GetFavorites renders the list of favorite images.
func (c *CatController) GetFavorites() {
	favoriteImages.Lock()
	defer favoriteImages.Unlock()

	c.Data["FavoriteImages"] = favoriteImages.Images
	c.TplName = "cat_favorites.tpl" // Assuming you have a separate template for displaying favorites.
	c.Render()
}


// BreedsController handles requests related to cat breeds.


type BreedInfo struct {
	ID		  	string `json:"id"`
	Origin	  	string `json:"origin"`
	Name        string `json:"name"`
	Info        string `json:"description"`
	Wikipedia   string `json:"wikipedia_url"`
	ImageURLs   []string `json:"image_urls"`
}

// GetBreedsAndBreedInfo fetches the list of available breeds and default breed information.
func (c *CatController) GetBreedsAndBreedInfo() {
    apiKey := web.AppConfig.DefaultString("catapi.key", "")
    apiURL := "https://api.thecatapi.com/v1/breeds"

    client := &http.Client{}
    req, err := http.NewRequest("GET", apiURL, nil)
    if err != nil {
        c.Data["error"] = "Failed to create request"
        c.TplName = "cat_breeds.tpl"
        c.Render()
        return
    }
    req.Header.Set("x-api-key", apiKey)

    resp, err := client.Do(req)
    if err != nil {
        c.Data["error"] = "Failed to fetch breeds"
        c.TplName = "cat_breeds.tpl"
        c.Render()
        return
    }
    defer resp.Body.Close()

    var breeds []map[string]interface{}
    if err := json.NewDecoder(resp.Body).Decode(&breeds); err != nil {
        c.Data["error"] = "Failed to parse response"
        c.TplName = "cat_breeds.tpl"
        c.Render()
        return
    }

    // Extract breed names for dropdown
    var breedNames []string
    for _, breed := range breeds {
        breedNames = append(breedNames, breed["name"].(string))
    }

    // Default to the first breed if it's not specified
    selectedBreed := c.GetString("breed")
    if selectedBreed == "" && len(breeds) > 0 {
        selectedBreed = breeds[0]["name"].(string)
    }

    // Fetch breed info for the selected breed
    var breedInfo BreedInfo
    for _, breed := range breeds {
        if breed["name"].(string) == selectedBreed {
            breedInfo.ID = breed["id"].(string)
            breedInfo.Origin = breed["origin"].(string)
            breedInfo.Name = breed["name"].(string)
            breedInfo.Info = breed["description"].(string)
            breedInfo.Wikipedia = breed["wikipedia_url"].(string)
        }
    }

    // Fetch breed-specific images
    apiURL = fmt.Sprintf("https://api.thecatapi.com/v1/images/search?breed_ids=%s&limit=5&api_key=%s", breedInfo.ID, apiKey)
    req, err = http.NewRequest("GET", apiURL, nil)
    if err != nil {
        c.Data["error"] = "Failed to create request for breed images"
        c.TplName = "cat_breeds.tpl"
        c.Render()
        return
    }
    req.Header.Set("x-api-key", apiKey)

    resp, err = client.Do(req)
    if err != nil {
        c.Data["error"] = "Failed to fetch breed images"
        c.TplName = "cat_breeds.tpl"
        c.Render()
        return
    }
    defer resp.Body.Close()

    var images []map[string]interface{}
    if err := json.NewDecoder(resp.Body).Decode(&images); err != nil {
        c.Data["error"] = "Failed to parse breed images"
        c.TplName = "cat_breeds.tpl"
        c.Render()
        return
    }

    // Extract image URLs
    for _, img := range images {
        breedInfo.ImageURLs = append(breedInfo.ImageURLs, img["url"].(string))
    }

    // Pass the breed info, breed names, and selected breed to the template
    c.Data["BreedInfo"] = breedInfo
    c.Data["Breeds"] = breedNames
    c.Data["SelectedBreed"] = selectedBreed
    c.TplName = "cat_breed_info.tpl"
    c.Render()
}