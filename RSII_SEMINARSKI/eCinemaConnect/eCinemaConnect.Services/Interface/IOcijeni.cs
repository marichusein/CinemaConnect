using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IOcijeni : IService<OcijeniFilmView, OcijeniFilmInsert, OcijeniFilmUpdate>
    {
        Task<double> GetProsjekZaFilmAsync(int idfilma);
        Task<List<OcijeniFilmView>> GetKomentareZaFilmAsync(int idFilma);
    }
}
