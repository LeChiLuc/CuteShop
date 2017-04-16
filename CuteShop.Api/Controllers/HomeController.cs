using AutoMapper;
using CuteShop.Api.Models;
using CuteShop.Model.Models;
using CuteShop.Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CuteShop.Api.Controllers
{
    public class HomeController : Controller
    {
        IProductCategoryService _productCategoryService;
        public HomeController(IProductCategoryService productCategoryService)
        {
            _productCategoryService = productCategoryService;
        }
        public ActionResult Index()
        {
            return View();
        }
        [ChildActionOnly]
        public ActionResult Header()
        {
            return PartialView();
        }
        [ChildActionOnly]
        public ActionResult Menu()
        {
            var model = _productCategoryService.GetAll();
            var listProductCategoryViewModel = Mapper.Map<IEnumerable<ProductCategory>, IEnumerable<ProductCategoryViewModel>>(model);
            return PartialView(listProductCategoryViewModel);
        }
        [ChildActionOnly]
        public ActionResult Slide()
        {
            return PartialView();
        }
    }
}