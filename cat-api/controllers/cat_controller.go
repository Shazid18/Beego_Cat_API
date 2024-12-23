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

type CatImage struct {
	ID  string `json:"id"`
	URL string `json:"url"`
}

type VoteRequest struct {
    ImageID string `json:"image_id"`
    SubID   string `json:"sub_id"`
    Value   int    `json:"value"`
}

type FavoriteRequest struct {
    ImageID string `json:"image_id"`
    SubID   string `json:"sub_id"`
}

type Favorite struct {
    ID        int      `json:"id"`
    ImageID   string   `json:"image_id"`
    SubID     string   `json:"sub_id"`
    Image     CatImage `json:"image"`
}

type BreedInfo struct {
	ID		  	string `json:"id"`
	Origin	  	string `json:"origin"`
	Name        string `json:"name"`
	Info        string `json:"description"`
	Wikipedia   string `json:"wikipedia_url"`
	ImageURLs   []string `json:"image_urls"`
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
	errCh := make(chan error, 1)  // Channel for errors

	go func() {
		// Prepare headers and make the request asynchronously
		headers := map[string]string{"x-api-key": apiKey}
		respBody, err := makeRequest("GET", apiURL, headers, nil)
		if err != nil {
			errCh <- err
			return
		}

		// Parse the response
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

	select {
	case catImage := <-ch: // Successfully received cat image
		c.Data["CatImage"] = catImage
	case err := <-errCh: // Error occurred
		c.Data["error"] = fmt.Sprintf("Failed to fetch image: %v", err)
	}

	c.TplName = "cat_image.tpl"
	c.Render()
}

// New method to handle voting with Go channels
func (c *CatController) VoteForImage() {
    apiKey := web.AppConfig.DefaultString("catapi.key", "")
    
    // Read the request body
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

    go func() {
        // Prepare headers and make the request asynchronously
        voteURL := "https://api.thecatapi.com/v1/votes"
        jsonData, _ := json.Marshal(voteReq)
        headers := map[string]string{"x-api-key": apiKey, "Content-Type": "application/json"}
        respBody, err := makeRequest("POST", voteURL, headers, jsonData)
        if err != nil {
            errCh <- err
            return
        }

        // Parse the response
        var result map[string]interface{}
        if err := json.Unmarshal(respBody, &result); err != nil {
            errCh <- err
            return
        }

        ch <- result
    }()

    select {
    case result := <-ch: // Successfully received the result
        c.Data["json"] = result
    case err := <-errCh: // Error occurred
        c.Data["json"] = map[string]interface{}{"error": fmt.Sprintf("Failed to submit vote: %v", err)}
    }

    c.ServeJSON()
}

// AddToFavorites with Go channels
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

    go func() {
        // Prepare headers and make the request asynchronously
        favURL := "https://api.thecatapi.com/v1/favourites"
        jsonData, _ := json.Marshal(favReq)
        headers := map[string]string{"x-api-key": apiKey, "Content-Type": "application/json"}
        respBody, err := makeRequest("POST", favURL, headers, jsonData)
        if err != nil {
            errCh <- err
            return
        }

        // Parse the response
        var result map[string]interface{}
        if err := json.Unmarshal(respBody, &result); err != nil {
            errCh <- err
            return
        }

        ch <- result
    }()

    select {
    case result := <-ch: // Successfully received the result
        c.Data["json"] = result
    case err := <-errCh: // Error occurred
        c.Data["json"] = map[string]interface{}{"error": fmt.Sprintf("Failed to add to favorites: %v", err)}
    }

    c.ServeJSON()
}

// GetFavorites with Go channels
func (c *CatController) GetFavorites() {
    apiKey := web.AppConfig.DefaultString("catapi.key", "")
    
    ch := make(chan []Favorite, 1) // Channel for result
    errCh := make(chan error, 1)   // Channel for errors

    go func() {
        // Prepare headers and make the request asynchronously
        reqURL := "https://api.thecatapi.com/v1/favourites"
        headers := map[string]string{"x-api-key": apiKey}
        respBody, err := makeRequest("GET", reqURL, headers, nil)
        if err != nil {
            errCh <- err
            return
        }

        // Parse the response
        var favorites []Favorite
        if err := json.Unmarshal(respBody, &favorites); err != nil {
            errCh <- err
            return
        }

        ch <- favorites
    }()

    select {
    case favorites := <-ch: // Successfully received favorites
        c.Data["Favorites"] = favorites
    case err := <-errCh: // Error occurred
        c.Data["error"] = fmt.Sprintf("Failed to fetch favorites: %v", err)
    }

    c.TplName = "favorites.tpl"
    c.Render()
}

// DeleteFavorite with Go channels
func (c *CatController) DeleteFavorite() {
    apiKey := web.AppConfig.DefaultString("catapi.key", "")
    favoriteID := c.Ctx.Input.Param(":id")
    
    ch := make(chan map[string]interface{}, 1) // Channel for API response
    errCh := make(chan error, 1) // Channel for errors

    go func() {
        // Prepare headers and make the request asynchronously
        reqURL := fmt.Sprintf("https://api.thecatapi.com/v1/favourites/%s", favoriteID)
        headers := map[string]string{"x-api-key": apiKey}
        respBody, err := makeRequest("DELETE", reqURL, headers, nil)
        if err != nil {
            errCh <- err
            return
        }

        // Parse the response
        var result map[string]interface{}
        if err := json.Unmarshal(respBody, &result); err != nil {
            errCh <- err
            return
        }

        ch <- result
    }()

    select {
    case result := <-ch: // Successfully deleted favorite
        c.Data["json"] = map[string]interface{}{"message": "Favorite deleted successfully", "result": result}
    case err := <-errCh: // Error occurred
        c.Data["json"] = map[string]interface{}{"error": fmt.Sprintf("Failed to delete favorite: %v", err)}
    }

    c.ServeJSON()
}




// BreedsController handles requests related to cat breeds.

// GetBreedsAndBreedInfo fetches the list of available breeds and breed information concurrently.
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

	// Channels for receiving data from both API requests and handling errors.
	breedsChannel := make(chan []map[string]interface{}, 1)
	imagesChannel := make(chan []map[string]interface{}, 1)
	errorChannel := make(chan error, 2) // A buffer for two potential errors

	// Goroutine for fetching breeds
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

	// Wait for the breeds response or error
	var breeds []map[string]interface{}
	select {
	case breeds = <-breedsChannel:
		// Successfully fetched breed data
	case err := <-errorChannel:
		// Error occurred fetching breed data
		c.Data["error"] = fmt.Sprintf("Failed to fetch breeds: %v", err)
		c.TplName = "cat_breeds.tpl"
		c.Render()
		return
	}

	// Extract breed names for dropdown
	var breedNames []string
	for _, breed := range breeds {
		breedNames = append(breedNames, breed["name"].(string))
	}

	// Default to the first breed if not specified
	selectedBreed := c.GetString("breed")
	if selectedBreed == "" && len(breeds) > 0 {
		selectedBreed = breeds[0]["name"].(string)
	}

	// Prepare breed info for the selected breed
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

	// Goroutine to fetch images for the selected breed
	go func() {
		apiURL = fmt.Sprintf("https://api.thecatapi.com/v1/images/search?breed_ids=%s&limit=5&api_key=%s", breedInfo.ID, apiKey)
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

	// Wait for the images response or error
	var images []map[string]interface{}
	select {
	case images = <-imagesChannel:
		// Successfully fetched breed images
	case err := <-errorChannel:
		// Error occurred fetching breed images
		c.Data["error"] = fmt.Sprintf("Failed to fetch breed images: %v", err)
		c.TplName = "cat_breeds.tpl"
		c.Render()
		return
	}

	// Extract image URLs and add to breedInfo
	for _, img := range images {
		breedInfo.ImageURLs = append(breedInfo.ImageURLs, img["url"].(string))
	}

	// Pass the breed data and images to the template
	c.Data["BreedInfo"] = breedInfo
	c.Data["Breeds"] = breedNames
	c.Data["SelectedBreed"] = selectedBreed
	c.TplName = "cat_breed_info.tpl"
	c.Render()
}