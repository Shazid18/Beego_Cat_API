package controllers

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"io/ioutil"
	"github.com/beego/beego/v2/server/web"
)

// CatController handles requests related to cat images.
type CatController struct {
	web.Controller
}

// CatImage represents a cat image with ID and URL.
type CatImage struct {
	ID  string `json:"id"`
	URL string `json:"url"`
}

// VoteRequest contains the information required to vote on a cat image.
type VoteRequest struct {
	ImageID string `json:"image_id"`
	SubID   string `json:"sub_id"`
	Value   int    `json:"value"`
}

// FavoriteRequest contains the information required to add a cat image to favorites.
type FavoriteRequest struct {
	ImageID string `json:"image_id"`
	SubID   string `json:"sub_id"`
}

// Favorite represents a cat image in the favorites list.
type Favorite struct {
	ID        int      `json:"id"`
	ImageID   string   `json:"image_id"`
	SubID     string   `json:"sub_id"`
	Image     CatImage `json:"image"`
}

// BreedInfo contains information about a specific cat breed.
type BreedInfo struct {
	ID         string   `json:"id"`
	Origin     string   `json:"origin"`
	Name       string   `json:"name"`
	Info       string   `json:"description"`
	Wikipedia  string   `json:"wikipedia_url"`
	ImageURLs  []string `json:"image_urls"`
}

// Helper function to make HTTP requests concurrently
func makeRequest(method, url string, headers map[string]string, body []byte) (responseBody []byte, err error) {
	client := &http.Client{}
	req, err := http.NewRequest(method, url, bytes.NewBuffer(body))
	if err != nil {
		return nil, err
	}

	// Set headers
	for key, value := range headers {
		req.Header.Set(key, value)
	}

	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	responseBody, err = ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	return responseBody, nil
}

// GetRandomCatImage fetches a random cat image from The Cat API and renders it on the page.
func (c *CatController) GetRandomCatImage() {
	apiKey := web.AppConfig.DefaultString("catapi.key", "")
	apiURL := "https://api.thecatapi.com/v1/images/search"

	ch := make(chan CatImage, 1) // Channel for image result
	errCh := make(chan error, 1) // Channel for errors

	// Fetch the random cat image asynchronously
	go func() {
		headers := map[string]string{"x-api-key": apiKey}
		respBody, err := makeRequest("GET", apiURL, headers, nil)
		if err != nil {
			errCh <- err
			return
		}

		var images []CatImage
		if err := json.Unmarshal(respBody, &images); err != nil {
			errCh <- err
			return
		}

		if len(images) > 0 {
			ch <- images[0] // Send the first image to the channel
		} else {
			errCh <- fmt.Errorf("No image found")
		}
	}()

	// Handle result or error
	select {
	case catImage := <-ch:
		c.Data["CatImage"] = catImage
	case err := <-errCh:
		c.Data["error"] = fmt.Sprintf("Failed to fetch image: %v", err)
	}

	c.TplName = "cat_image.tpl"
	c.Render()
}

// VoteForImage handles voting for a cat image.
func (c *CatController) VoteForImage() {
    apiKey := web.AppConfig.DefaultString("catapi.key", "")
    
    body, err := ioutil.ReadAll(c.Ctx.Request.Body)
    if err != nil {
        c.Data["json"] = map[string]interface{}{"error": "Failed to read request body"}
        c.ServeJSON()
        return
    }

    var voteReq VoteRequest
    if err := json.Unmarshal(body, &voteReq); err != nil {
        c.Data["json"] = map[string]interface{}{"error": "Invalid request data: " + err.Error()}
        c.ServeJSON()
        return
    }

    ch := make(chan map[string]interface{}, 1) // Channel for API response
    errCh := make(chan error, 1) // Channel for errors

    // Send vote data asynchronously
    go func() {
        voteURL := "https://api.thecatapi.com/v1/votes"
        jsonData, _ := json.Marshal(voteReq)
        headers := map[string]string{"x-api-key": apiKey, "Content-Type": "application/json"}
        respBody, err := makeRequest("POST", voteURL, headers, jsonData)
        if err != nil {
            errCh <- err
            return
        }

        var result map[string]interface{}
        if err := json.Unmarshal(respBody, &result); err != nil {
            errCh <- err
            return
        }

        ch <- result
    }()

    // Handle result or error
    select {
    case result := <-ch:
        c.Data["json"] = result
    case err := <-errCh:
        c.Data["json"] = map[string]interface{}{"error": fmt.Sprintf("Failed to submit vote: %v", err)}
    }

    c.ServeJSON()
}

// AddToFavorites handles adding a cat image to favorites.
func (c *CatController) AddToFavorites() {
    apiKey := web.AppConfig.DefaultString("catapi.key", "")
    
    body, err := ioutil.ReadAll(c.Ctx.Request.Body)
    if err != nil {
        c.Data["json"] = map[string]interface{}{"error": "Failed to read request body"}
        c.ServeJSON()
        return
    }

    var favReq FavoriteRequest
    if err := json.Unmarshal(body, &favReq); err != nil {
        c.Data["json"] = map[string]interface{}{"error": "Invalid request data"}
        c.ServeJSON()
        return
    }

    ch := make(chan map[string]interface{}, 1) // Channel for API response
    errCh := make(chan error, 1) // Channel for errors

    // Add image to favorites asynchronously
    go func() {
        favURL := "https://api.thecatapi.com/v1/favourites"
        jsonData, _ := json.Marshal(favReq)
        headers := map[string]string{"x-api-key": apiKey, "Content-Type": "application/json"}
        respBody, err := makeRequest("POST", favURL, headers, jsonData)
        if err != nil {
            errCh <- err
            return
        }

        var result map[string]interface{}
        if err := json.Unmarshal(respBody, &result); err != nil {
            errCh <- err
            return
        }

        ch <- result
    }()

    // Handle result or error
    select {
    case result := <-ch:
        c.Data["json"] = result
    case err := <-errCh:
        c.Data["json"] = map[string]interface{}{"error": fmt.Sprintf("Failed to add to favorites: %v", err)}
    }

    c.ServeJSON()
}

// GetFavorites fetches the list of favorite cat images.
func (c *CatController) GetFavorites() {
    apiKey := web.AppConfig.DefaultString("catapi.key", "")
    
    ch := make(chan []Favorite, 1) // Channel for result
    errCh := make(chan error, 1)   // Channel for errors

    // Fetch favorites asynchronously
    go func() {
        reqURL := "https://api.thecatapi.com/v1/favourites"
        headers := map[string]string{"x-api-key": apiKey}
        respBody, err := makeRequest("GET", reqURL, headers, nil)
        if err != nil {
            errCh <- err
            return
        }

        var favorites []Favorite
        if err := json.Unmarshal(respBody, &favorites); err != nil {
            errCh <- err
            return
        }

        ch <- favorites
    }()

    // Handle result or error
    select {
    case favorites := <-ch:
        c.Data["Favorites"] = favorites
    case err := <-errCh:
        c.Data["error"] = fmt.Sprintf("Failed to fetch favorites: %v", err)
    }

    c.TplName = "favorites.tpl"
    c.Render()
}

// DeleteFavorite removes a cat image from the favorites list.
func (c *CatController) DeleteFavorite() {
    apiKey := web.AppConfig.DefaultString("catapi.key", "")
    favoriteID := c.Ctx.Input.Param(":id")
    
    ch := make(chan map[string]interface{}, 1) // Channel for API response
    errCh := make(chan error, 1) // Channel for errors

    // Remove favorite asynchronously
    go func() {
        reqURL := fmt.Sprintf("https://api.thecatapi.com/v1/favourites/%s", favoriteID)
        headers := map[string]string{"x-api-key": apiKey}
        respBody, err := makeRequest("DELETE", reqURL, headers, nil)
        if err != nil {
            errCh <- err
            return
        }

        var result map[string]interface{}
        if err := json.Unmarshal(respBody, &result); err != nil {
            errCh <- err
            return
        }

        ch <- result
    }()

    // Handle result or error
    select {
    case result := <-ch:
        c.Data["json"] = map[string]interface{}{"message": "Favorite deleted successfully", "result": result}
    case err := <-errCh:
        c.Data["json"] = map[string]interface{}{"error": fmt.Sprintf("Failed to delete favorite: %v", err)}
    }

    c.ServeJSON()
}

// GetBreedsAndBreedInfo fetches cat breeds and breed information concurrently.
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

	breedsChannel := make(chan []map[string]interface{}, 1)
	imagesChannel := make(chan []map[string]interface{}, 1)
	errorChannel := make(chan error, 2) 

	// Fetch breed data asynchronously
	go func() {
		resp, err := client.Do(req)
		if err != nil {
			errorChannel <- err
			return
		}
		defer resp.Body.Close()

		var breeds []map[string]interface{}
		if err := json.NewDecoder(resp.Body).Decode(&breeds); err != nil {
			errorChannel <- err
			return
		}

		breedsChannel <- breeds
	}()

	// Handle breed response or error
	var breeds []map[string]interface{}
	select {
	case breeds = <-breedsChannel:
	case err := <-errorChannel:
		c.Data["error"] = fmt.Sprintf("Failed to fetch breeds: %v", err)
		c.TplName = "cat_breeds.tpl"
		c.Render()
		return
	}

	// Extract breed names and prepare breed info
	var breedNames []string
	for _, breed := range breeds {
		breedNames = append(breedNames, breed["name"].(string))
	}

	selectedBreed := c.GetString("breed")
	if selectedBreed == "" && len(breeds) > 0 {
		selectedBreed = breeds[0]["name"].(string)
	}

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

	// Fetch breed images asynchronously
	go func() {
		apiURL = fmt.Sprintf("https://api.thecatapi.com/v1/images/search?breed_ids=%s&limit=8&api_key=%s", breedInfo.ID, apiKey)
		req, err := http.NewRequest("GET", apiURL, nil)
		if err != nil {
			errorChannel <- err
			return
		}
		req.Header.Set("x-api-key", apiKey)

		resp, err := client.Do(req)
		if err != nil {
			errorChannel <- err
			return
		}
		defer resp.Body.Close()

		var images []map[string]interface{}
		if err := json.NewDecoder(resp.Body).Decode(&images); err != nil {
			errorChannel <- err
			return
		}

		imagesChannel <- images
	}()

	// Handle image response or error
	var images []map[string]interface{}
	select {
	case images = <-imagesChannel:
	case err := <-errorChannel:
		c.Data["error"] = fmt.Sprintf("Failed to fetch breed images: %v", err)
		c.TplName = "cat_breeds.tpl"
		c.Render()
		return
	}

	// Extract image URLs and add to breedInfo
	for _, img := range images {
		breedInfo.ImageURLs = append(breedInfo.ImageURLs, img["url"].(string))
	}

	// Pass data to template
	c.Data["BreedInfo"] = breedInfo
	c.Data["Breeds"] = breedNames
	c.Data["SelectedBreed"] = selectedBreed
	c.TplName = "cat_breed_info.tpl"
	c.Render()
}
