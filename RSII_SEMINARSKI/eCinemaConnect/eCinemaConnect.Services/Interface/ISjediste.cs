using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface ISjediste : IService<SjedistaView, SjedistaInsert, SjedistaUpdate>
    {
        Task<SjedistaView> GetByIdAsync(int id);
        Task<SjedistaView> AddSpecialAsync(SjedistaInsert sjedistaInsert);
        Task<List<SjedistaView>> GetAllWithPovezanoSvojstvoAsync();
        Task<List<SjedistaView>> GetAllBySalaAsync(int id);
    }
}
