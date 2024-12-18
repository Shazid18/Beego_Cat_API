package controllers

import (
	"encoding/json"
	"net/http"

	"github.com/beego/beego/v2/server/web"
)

// CatController handles requests related to cat images.
type CatController struct {
	web.Controller
}

// CatImage represents the structure of a cat image from The Cat API.
type CatImage struct {
	URL string `json:"url"`
}

// GetCatImages fetches cat images from The Cat API and renders the template.
func (c *CatController) GetCatImages() {
	apiKey := web.AppConfig.DefaultString("catapi.key", "")
	apiURL := "https://api.thecatapi.com/v1/images/search?limit=10"

	// Channel to handle asynchronous API response
	ch := make(chan []CatImage)
	go func() {
		client := &http.Client{}
		req, err := http.NewRequest("GET", apiURL, nil)
		if err != nil {
			ch <- nil
			return
		}
		req.Header.Set("x-api-key", apiKey)

		resp, err := client.Do(req)
		if err != nil {
			ch <- nil
			return
		}
		defer resp.Body.Close()

		var catImages []CatImage
		if err := json.NewDecoder(resp.Body).Decode(&catImages); err != nil {
			ch <- nil
			return
		}
		ch <- catImages
	}()

	// Receive API response or handle errors
	catImages := <-ch
	if catImages == nil {
		c.Data["Error"] = "Failed to load cat images. Please try again."
		c.TplName = "error.tpl"
	} else {
		c.Data["CatImages"] = catImages
		c.TplName = "cat_image.tpl"
	}

	// Render the template
	c.Render()
}
