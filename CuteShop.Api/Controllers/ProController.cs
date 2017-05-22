using AutoMapper;
using CuteShop.Api.Infrastructure.Core;
using CuteShop.Api.Models;
using CuteShop.Common;
using CuteShop.Model.Models;
using CuteShop.Service;
using CuteShop.Data.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;

namespace CuteShop.Api.Controllers
{
    public class ProController : Controller
    {
        IProductService _productService;
        IProductCategoryService _productCategoryService;
        IProductRepository _productRepository;
        public ProController(IProductService productService, IProductCategoryService productCategoryService, IProductRepository productRepository)
        {
            this._productRepository = productRepository;
            this._productService = productService;
            this._productCategoryService = productCategoryService;
        }
        // GET: Pro
        [OutputCache(Duration = 3600, Location = System.Web.UI.OutputCacheLocation.Server)]
        public ActionResult Detail(int id)
        {
            var productModel = _productService.GetById(id);
            var viewModel = Mapper.Map<Product, ProductViewModel>(productModel);
            var relatedProduct = _productService.GetReatedProducts(id, 6);
            ViewBag.RelatedProducts = Mapper.Map<IEnumerable<Product>, IEnumerable<ProductViewModel>>(relatedProduct);
            var lastestProductModel = _productService.GetLastestProduct(5);
            var topHotProductModel = _productService.GetSpecialProduct(5);
            var lastestProductViewModel = Mapper.Map<IEnumerable<Product>, IEnumerable<ProductViewModel>>(lastestProductModel);
            var topHotProductViewModel = Mapper.Map<IEnumerable<Product>, IEnumerable<ProductViewModel>>(topHotProductModel);
            ViewBag.productCategoryView = _productService.GetAll();
            ViewBag.lastestProductView = lastestProductViewModel;
            ViewBag.topHotProductView = topHotProductViewModel;

            List<string> listImages = new JavaScriptSerializer().Deserialize<List<string>>(viewModel.MoreImages);
            ViewBag.MoreImages = listImages;
            ViewBag.Tags = Mapper.Map<IEnumerable<Tag>,IEnumerable<TagViewModel>>(_productService.GetListTagByProductId(id));
            return View(viewModel);
        }
        [OutputCache(Duration = 3600, Location = System.Web.UI.OutputCacheLocation.Server)]
        public ActionResult ListByTag(string tagId,int page =1)
        {
            int pageSize = int.Parse(ConfigHelper.GetByKey("pageSize"));
            int totalRow = 0;
            var listProduct = _productService.GetListProductByTag(tagId, page, pageSize, out totalRow);
            var productViewModel = Mapper.Map<IEnumerable<Product>, IEnumerable<ProductViewModel>>(listProduct);
            var totalPage = (int)Math.Ceiling((double)totalRow / pageSize);

            var lastestProductModel = _productService.GetLastestProduct(5);
            var topHotProductModel = _productService.GetSpecialProduct(5);
            var lastestProductViewModel = Mapper.Map<IEnumerable<Product>, IEnumerable<ProductViewModel>>(lastestProductModel);
            var topHotProductViewModel = Mapper.Map<IEnumerable<Product>, IEnumerable<ProductViewModel>>(topHotProductModel);
            ViewBag.lastestProductView = lastestProductViewModel;
            ViewBag.topHotProductView = topHotProductViewModel;

            ViewBag.Tag = Mapper.Map<Tag,TagViewModel>(_productService.GetTag(tagId));
            var paginationSet = new PaginationSet<ProductViewModel>()
            {
                Items = productViewModel,
                MaxPage = int.Parse(ConfigHelper.GetByKey("MaxPage")),
                Page = page,
                TotalCount = totalRow,
                TotalPages = totalPage
            };
            return View(paginationSet);
        }
        [OutputCache(Duration = 3600, Location = System.Web.UI.OutputCacheLocation.Server)]
        public ActionResult Category(int id, int page = 1, string sort = "")
        {
            int pageSize = int.Parse(ConfigHelper.GetByKey("pageSize"));
            int totalRow = 0;
            var listProduct = _productRepository.GetListProductByProductCategory(id, page, pageSize, sort, out totalRow);
            var productViewModel = Mapper.Map<IEnumerable<Product>, IEnumerable<ProductViewModel>>(listProduct);
            var totalPage = (int)Math.Ceiling((double)totalRow / pageSize);
            var category = _productCategoryService.GetById(id);

            var lastestProductModel = _productService.GetLastestProduct(5);
            var topHotProductModel = _productService.GetSpecialProduct(5);
            var lastestProductViewModel = Mapper.Map<IEnumerable<Product>, IEnumerable<ProductViewModel>>(lastestProductModel);
            var topHotProductViewModel = Mapper.Map<IEnumerable<Product>, IEnumerable<ProductViewModel>>(topHotProductModel);
            ViewBag.lastestProductView = lastestProductViewModel;
            ViewBag.topHotProductView = topHotProductViewModel;

            ViewBag.Category = Mapper.Map<ProductCategory, ProductCategoryViewModel>(category);
            var paginationSet = new PaginationSet<ProductViewModel>()
            {
                Items = productViewModel,
                MaxPage = int.Parse(ConfigHelper.GetByKey("MaxPage")),
                Page = page,
                TotalCount = totalRow,
                TotalPages = totalPage
            };
            return View(paginationSet);
        }
        [OutputCache(Duration = 3600, Location = System.Web.UI.OutputCacheLocation.Server)]
        public ActionResult Search(string keyword, int page = 1, string sort = "")
        {
            int pageSize = int.Parse(ConfigHelper.GetByKey("pageSize"));
            int totalRow = 0;
            var listProduct = _productService.Search(keyword, page, pageSize, sort, out totalRow);
            var productViewModel = Mapper.Map<IEnumerable<Product>, IEnumerable<ProductViewModel>>(listProduct);
            var totalPage = (int)Math.Ceiling((double)totalRow / pageSize);

            var lastestProductModel = _productService.GetLastestProduct(5);
            var topHotProductModel = _productService.GetSpecialProduct(5);
            var lastestProductViewModel = Mapper.Map<IEnumerable<Product>, IEnumerable<ProductViewModel>>(lastestProductModel);
            var topHotProductViewModel = Mapper.Map<IEnumerable<Product>, IEnumerable<ProductViewModel>>(topHotProductModel);
            ViewBag.lastestProductView = lastestProductViewModel;
            ViewBag.topHotProductView = topHotProductViewModel;

            ViewBag.Keyword = keyword;
            var paginationSet = new PaginationSet<ProductViewModel>()
            {
                Items = productViewModel,
                MaxPage = int.Parse(ConfigHelper.GetByKey("MaxPage")),
                Page = page,
                TotalCount = totalRow,
                TotalPages = totalPage
            };
            return View(paginationSet);
        }
        public JsonResult GetListProductByName(string keyword)
       {
            var model = _productService.GetListProductByName(keyword);
            return Json(new
            {
                data = model
            }, JsonRequestBehavior.AllowGet);
        }
    }
}