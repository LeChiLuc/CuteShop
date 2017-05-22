using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace CuteShop.Api
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            routes.MapRoute(
                name: "Search",
                url: "tim-kiem.html",
                defaults: new { controller = "Pro", action = "Search", id = UrlParameter.Optional },
                namespaces: new string[] { "CuteShop.Api.Controllers" }
            );
            routes.MapRoute(
              name: "Cart",
              url: "gio-hang.html",
              defaults: new { controller = "ShoppingCart", action = "Index", tagId = UrlParameter.Optional },
              namespaces: new string[] { "CuteShop.Api.Controllers" }
          );
            routes.MapRoute(
             name: "Checkout",
             url: "thanh-toan.html",
             defaults: new { controller = "ShoppingCart", action = "Checkout", tagId = UrlParameter.Optional },
             namespaces: new string[] { "CuteShop.Api.Controllers" }
         );
            routes.MapRoute(
                name: "TagList",
                url: "tag/{tagId}.html",
                defaults: new { controller = "Pro", action = "ListByTag", tagId = UrlParameter.Optional },
                namespaces: new string[] { "CuteShop.Api.Controllers" }
            );
            routes.MapRoute(
                name: "Product Category",
                url: "{alias}.pc-{id}.html",
                defaults: new { controller = "Pro", action = "Category", id = UrlParameter.Optional },
                namespaces: new string[] { "CuteShop.Api.Controllers" }
            );
            routes.MapRoute(
                name: "Product",
                url: "{alias}.p-{id}.html",
                defaults: new { controller = "Pro", action = "Detail", id = UrlParameter.Optional },
                namespaces: new string[] { "CuteShop.Api.Controllers" }
            );
            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional },
                namespaces: new string[] { "CuteShop.Api.Controllers" }
            );
        }
    }
}
