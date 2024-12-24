package routers

import (
	"cat-api/controllers"
	beego "github.com/beego/beego/v2/server/web"
)

func init() {
	beego.Router("/", &controllers.CatController{}, "get:GetRandomCatImage")
	beego.Router("/cats/vote", &controllers.CatController{}, "post:VoteForImage")

	beego.Router("/cats/favorites", &controllers.CatController{}, "post:AddToFavorites")
	beego.Router("/cats/favorites", &controllers.CatController{}, "get:GetFavorites")
	beego.Router("/cats/favorites/:id", &controllers.CatController{}, "delete:DeleteFavorite")

	beego.Router("/cats/breedinfo", &controllers.CatController{}, "get:GetBreedsAndBreedInfo")
}
