using System;

namespace CuteShop.Data.Infrastructure
{
    public interface IDbFactory : IDisposable
    {
        CuteShopDbContext Init();
    }
}