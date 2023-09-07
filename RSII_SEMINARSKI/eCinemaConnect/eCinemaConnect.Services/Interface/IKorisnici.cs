using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static eCinemaConnect.Services.Service.KorisniciService;

namespace eCinemaConnect.Services.Interface
{
    public interface IKorisnici : IService<KorisniciView, KorisniciInsert, KorisniciUpdate>
    {
        KorisniciView Login(KorisniciLogin login);
        SiginUpResult SiginUp(KorisniciRegistration registration);
        KorisniciView UpdateProfiil(int id, KorisniciUpdate obj);

    }
}
