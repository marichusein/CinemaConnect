using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IGlumci : IService<GlumciView, GlumciInsert, GlumciUpdate>
    {
        Task<IEnumerable<FilmoviView>> VratiFilmoveZaGlumcaAsync(int glumacId);
    }
}
