using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using System.Threading.Tasks;
using static eCinemaConnect.Services.Service.KorisniciService;

namespace eCinemaConnect.Services.Interface
{
    public interface IKorisnici : IService<KorisniciView, KorisniciInsert, KorisniciUpdate>
    {
        Task<KorisniciView> LoginAsync(KorisniciLogin login);
        Task<KorisniciView> LoginAdminAsync(KorisniciLogin login);
        Task<SiginUpResult> SiginUpAsync(KorisniciRegistration registration);
        Task<KorisniciView> UpdateProfiilAsync(int id, KorisniciUpdate obj);
        Task SendMailAsync(int korisnikID);
        Task SendPurchaseConfirmationEmailAsync(int korisnikID, string filmNaziv, DateTime datumPrikazivanja, string sala, int brojKarata, decimal ukupnaCijena);
    }
}
