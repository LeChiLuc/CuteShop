namespace CuteShop.Data.Infrastructure
{
    public interface IUnitOfWork
    {
        void Commit();
    }
}