using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IProjekcije
    {
        Task<List<ProjekcijeView>> GetAllAsync();
        Task<List<ProjekcijeView>> GetAktivneProjekcijeAsync();
        Task<ProjekcijeView> AddProjekcijuAsync(ProjekcijeInsert projekcijaInsert);
        Task<ProjekcijeView> UpdateProjekcijuAsync(int id, ProjekcijeUpdate projekcijeUpdate);
        Task<ProjekcijeView> GetByIdAsync(int id);
        Task<bool> DeleteByIdAsync(int id);
        Task<List<ProjekcijeView>> GetByFilmAsync(int id);
        Task<List<ProjekcijeView>> GetByFilmAktivneAsync(int id);
        Task<List<SjedistaViewProjekcija>> GetSjedistaByProjekcijaAsync(int projekcijaID);
    }
}
