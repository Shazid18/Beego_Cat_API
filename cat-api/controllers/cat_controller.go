
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


// New method to handle voting
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

    // For debugging
    fmt.Printf("Received vote request: %+v\n", voteReq)

    voteURL := "https://api.thecatapi.com/v1/votes"
    jsonData, err := json.Marshal(voteReq)
    if err != nil {
        c.Data["json"] = map[string]interface{}{"error": "Failed to process vote"}
        c.ServeJSON()
        return
    }

    client := &http.Client{}
    req, err := http.NewRequest("POST", voteURL, bytes.NewBuffer(jsonData))
    if err != nil {
        c.Data["json"] = map[string]interface{}{"error": "Failed to create vote request"}
        c.ServeJSON()
        return
    }

    req.Header.Set("x-api-key", apiKey)
    req.Header.Set("Content-Type", "application/json")

    resp, err := client.Do(req)
    if err != nil {
        c.Data["json"] = map[string]interface{}{"error": "Failed to submit vote"}
        c.ServeJSON()
        return
    }
    defer resp.Body.Close()

    // Read and parse the response
    respBody, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        c.Data["json"] = map[string]interface{}{"error": "Failed to read response"}
        c.ServeJSON()
        return
    }

    // For debugging
    fmt.Printf("API Response: %s\n", string(respBody))

    var result map[string]interface{}
    if err := json.Unmarshal(respBody, &result); err != nil {
        c.Data["json"] = map[string]interface{}{"error": "Failed to parse response"}
        c.ServeJSON()
        return
    }

    c.Data["json"] = result
    c.ServeJSON()
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

	// Channel to receive response data
	breedsChannel := make(chan []map[string]interface{})
	errorChannel := make(chan error)

	// Goroutine for fetching breed data
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

	var breeds []map[string]interface{}
	select {
	case breeds = <-breedsChannel:
		// Successfully fetched breed data
	case err := <-errorChannel:
		// Handle error
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

	// Default to the first breed if it's not specified
	selectedBreed := c.GetString("breed")
	if selectedBreed == "" && len(breeds) > 0 {
		selectedBreed = breeds[0]["name"].(string)
	}

	// Find breed info for selected breed
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

	// Channel to receive breed images
	imagesChannel := make(chan []map[string]interface{})
	go func() {
		// Fetch breed-specific images
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

	var images []map[string]interface{}
	select {
	case images = <-imagesChannel:
		// Successfully fetched breed images
	case err := <-errorChannel:
		// Handle error
		c.Data["error"] = fmt.Sprintf("Failed to fetch breed images: %v", err)
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