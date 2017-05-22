using CuteShop.Data.Infrastructure;
using CuteShop.Model.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CuteShop.Data.Repositories
{
    public interface IProductRepository : IRepository<Product>
    {
        IEnumerable<Product> GetListProductByTag(string tagId, int page, int pageSize, out int totalRow);
        IEnumerable<Product> GetListProductByProductCategory(int categoryID, int page, int pageSize, string sort, out int totalRow);
    }

    public class ProductRepository : RepositoryBase<Product>, IProductRepository
    {
        public ProductRepository(IDbFactory dbFactory) : base(dbFactory)
        {
        }

        public IEnumerable<Product> GetListProductByProductCategory(int categoryID, int page, int pageSize, string sort, out int totalRow)
        {
            var query = from p in DbContext.Products
                        join pc in DbContext.ProductCategories
                        on p.CategoryID equals pc.ID
                        where p.Status && (p.CategoryID == categoryID || pc.ParentID == categoryID)
                        orderby p.CreatedDate descending
                        select p;
            switch (sort)
            {
                case "Z-A":
                    query = query.OrderByDescending(x => x.Name);
                    break;
                case "A-Z":
                    query = query.OrderBy(x => x.Name);
                    break;
                case "price":
                    query = query.OrderBy(x => x.Price);
                    break;
                default:
                    query = query.OrderByDescending(x => x.CreatedDate);
                    break;
            }
            totalRow = query.Count();
            return query.Skip((page - 1) * pageSize).Take(pageSize);
        }

        public IEnumerable<Product> GetListProductByTag(string tagId, int page, int pageSize, out int totalRow)
        {
            var query = from p in DbContext.Products
                        join pt in DbContext.ProductTags
                        on p.ID equals pt.ProductID
                        where pt.TagID == tagId
                        select p;
            totalRow = query.Count();

            return query.OrderByDescending(x => x.CreatedDate).Skip((page - 1) * pageSize).Take(pageSize);
        }

    }
}
