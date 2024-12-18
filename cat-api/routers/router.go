package routers

import (
	"cat-api/controllers"
	beego "github.com/beego/beego/v2/server/web"
)

func init() {
    beego.Router("/", &controllers.MainController{})
	beego.Router("/api/cats", &controllers.CatController{}, "get:GetCatImages")
	beego.Router("/cats", &controllers.CatController{}, "get:GetCatImages")
}
