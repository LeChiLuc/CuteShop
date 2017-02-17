using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CuteShop.Data.Infrastructure
{
    public class DbFactory : Disposable, IDbFactory
    {
        private CuteShopDbContext dbContext;

        public CuteShopDbContext Init()
        {
            return dbContext ?? (dbContext = new CuteShopDbContext());
        }

        protected override void DisposeCore()
        {
            if (dbContext != null)
                dbContext.Dispose();
        }
    }
}
