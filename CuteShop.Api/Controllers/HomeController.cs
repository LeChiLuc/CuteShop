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
        ISlideService _slideService;
        IProductService _productService;

        public HomeController(IProductCategoryService productCategoryService, ISlideService slideService, IProductService productService)
        {
            _productCategoryService = productCategoryService;
            _slideService = slideService;
            _productService = productService;
        }
        public ActionResult Index()
        {
            var lastestProductModel = _productService.GetLastestProduct(4);
            var topHotProductModel = _productService.GetSpecialProduct(4);
            var lastestProductViewModel = Mapper.Map<IEnumerable<Product>, IEnumerable<ProductViewModel>>(lastestProductModel);
            var topHotProductViewModel = Mapper.Map<IEnumerable<Product>, IEnumerable<ProductViewModel>>(topHotProductModel);

            ViewBag.lastestProductView = lastestProductViewModel;
            ViewBag.topHotProductView = topHotProductViewModel;
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
            var model = _slideService.GetSlides();
            var slideView = Mapper.Map<IEnumerable<Slide>, IEnumerable<SlideViewModel>>(model);
            return PartialView(slideView);
        }
    }
}