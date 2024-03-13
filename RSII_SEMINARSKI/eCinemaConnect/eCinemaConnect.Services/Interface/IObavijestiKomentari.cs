using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IKomentariObavijesti : IService<KomentariObavijestiView, KomentariObavijestiInsert, KomentariObavijestiUpdate>
    {
        Task<List<KomentariObavijestiView>> getByObavijestAsync(int obavijestId);
    }
}
