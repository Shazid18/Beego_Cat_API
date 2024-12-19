package routers

import (
	"cat-api/controllers"
	beego "github.com/beego/beego/v2/server/web"
)

func init() {
    beego.Router("/", &controllers.MainController{})
	beego.Router("/cats/random", &controllers.CatController{}, "get:GetRandomCatImage")
	beego.Router("/cats/favorites", &controllers.CatController{}, "post:AddToFavorites")
	beego.Router("/cats/favorites", &controllers.CatController{}, "get:GetFavorites")
	beego.Router("/cats/breeds", &controllers.MainController{})
}
