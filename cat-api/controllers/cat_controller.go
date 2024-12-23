
package controllers

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
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

// VoteOnCatImage handles voting on a cat image (upvote or downvote).
func (c *CatController) VoteOnCatImage() {
	// Retrieve necessary parameters from the POST request
	imageID := c.GetString("image_id")
	value := c.GetString("value")
	subID := "demo-0.120221667167041654" // Hardcoded unique ID for user

	// Check if image_id is valid (non-empty) and value is either 1 (upvote) or -1 (downvote)
	if imageID == "" || (value != "1" && value != "-1") {
		// Log the actual received data for debugging
		c.Ctx.Output.SetStatus(400)
		c.Data["json"] = map[string]interface{}{
			"error":      "Invalid image_id or value",
			"receivedId": imageID,
			"receivedValue": value,
		}
		c.ServeJSON()
		return
	}

	// Create the request body for voting
	voteData := map[string]interface{}{
		"image_id": imageID,
		"sub_id":   subID,
		"value":    value,
	}

	// Log the vote data to ensure correct payload
	c.Ctx.WriteString(fmt.Sprintf("Vote data: %v\n", voteData))

	voteJSON, err := json.Marshal(voteData)
	if err != nil {
		c.Ctx.Output.SetStatus(500)
		c.Data["json"] = map[string]string{"error": "Failed to marshal vote data"}
		c.ServeJSON()
		return
	}

	// Log the vote payload before sending the request
	fmt.Println("Vote Payload:", string(voteJSON))

	// Retrieve API Key from configuration and log it for debugging
	apiKey := web.AppConfig.DefaultString("catapi.key", "")
	if apiKey == "" {
		c.Ctx.Output.SetStatus(500)
		c.Data["json"] = map[string]string{"error": "API Key not found"}
		c.ServeJSON()
		return
	}
	fmt.Println("API Key:", apiKey) // Debugging log

	// Send the POST request to TheCatAPI to register the vote
	apiURL := "https://api.thecatapi.com/v1/votes"
	client := &http.Client{}
	req, err := http.NewRequest("POST", apiURL, bytes.NewBuffer(voteJSON))
	if err != nil {
		c.Ctx.Output.SetStatus(500)
		c.Data["json"] = map[string]string{"error": "Failed to create vote request"}
		c.ServeJSON()
		return
	}
	req.Header.Set("x-api-key", apiKey)
	req.Header.Set("Content-Type", "application/json")

	// Log the request headers for debugging
	fmt.Println("Request Headers:", req.Header)

	resp, err := client.Do(req)
	if err != nil {
		c.Ctx.Output.SetStatus(500)
		c.Data["json"] = map[string]string{"error": "Failed to send vote request"}
		c.ServeJSON()
		return
	}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusOK {
		c.Data["json"] = map[string]string{"message": "Vote submitted successfully"}
	} else {
		c.Ctx.Output.SetStatus(400)
		c.Data["json"] = map[string]string{"error": "Failed to submit vote", "status": resp.Status}
	}
	c.ServeJSON()
}



// Vote represents the structure of a vote returned by TheCatAPI.
type Vote struct {
	ID        string `json:"id"`
	ImageID   string `json:"image_id"`
	Value     int    `json:"value"`
	CreatedAt string `json:"created_at"`
}

// GetVotesBySubID fetches all votes associated with a given sub_id.
func (c *CatController) GetVotesBySubID() {
	// Fetch the sub_id (in this case, hardcoded for demo purposes)
	subID := "demo-0.120221667167041654"

	// API endpoint to fetch the votes by sub_id
	apiURL := fmt.Sprintf("https://api.thecatapi.com/v1/votes?sub_id=%s", subID)

	// Retrieve the API Key from Beego configuration
	apiKey := web.AppConfig.DefaultString("catapi.key", "")
	if apiKey == "" {
		c.Ctx.Output.SetStatus(500)
		c.Data["json"] = map[string]string{"error": "API Key not found"}
		c.ServeJSON()
		return
	}

	// Make the GET request to TheCatAPI to fetch votes
	client := &http.Client{}
	req, err := http.NewRequest("GET", apiURL, nil)
	if err != nil {
		c.Ctx.Output.SetStatus(500)
		c.Data["json"] = map[string]string{"error": "Failed to create request"}
		c.ServeJSON()
		return
	}
	req.Header.Set("x-api-key", apiKey)

	// Execute the request
	resp, err := client.Do(req)
	if err != nil {
		c.Ctx.Output.SetStatus(500)
		c.Data["json"] = map[string]string{"error": "Failed to fetch votes"}
		c.ServeJSON()
		return
	}
	defer resp.Body.Close()

	// Check for successful response
	if resp.StatusCode != http.StatusOK {
		c.Ctx.Output.SetStatus(resp.StatusCode)
		c.Data["json"] = map[string]string{"error": "Failed to fetch votes", "status": resp.Status}
		c.ServeJSON()
		return
	}

	// Decode the response body into a slice of Vote structs
	var votes []Vote
	if err := json.NewDecoder(resp.Body).Decode(&votes); err != nil {
		c.Ctx.Output.SetStatus(500)
		c.Data["json"] = map[string]string{"error": "Failed to parse response"}
		c.ServeJSON()
		return
	}

	// Return the list of votes as JSON
	c.Data["json"] = votes
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