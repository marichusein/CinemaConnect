using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IService<T, TInsert, TUpdate> where T : class where TInsert : class where TUpdate : class
    {
        Task<List<T>> GetAllAsync(params Expression<Func<T, object>>[] includeProperties);
        Task<T> AddObjAsync(TInsert Insert);
        Task<T> UpdateObjAsync(int id, TUpdate Update);
        Task<T> GetObjAsync(int id);
        Task<bool> DeleteByIdAsync(int id);
    }
}
