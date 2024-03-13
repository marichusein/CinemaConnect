using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IRecenzije : IService<RecenzijeView, RecenzijeInsert, RecenzijeUpdate>
    {
        Task<RecenzijeView> GetByIdAsync(int id);
        Task<RecenzijeView> AddRecenzijuAsync(RecenzijeInsert recenzijeInsert);
        Task<List<RecenzijeView>> GetAllWithPovezanoSvojstvoAsync();
    }
}
