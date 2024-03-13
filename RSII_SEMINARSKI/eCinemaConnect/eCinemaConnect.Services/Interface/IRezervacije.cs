using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IRezervacije : IService<RezervacijaView, RezervacijaInsert, RezervacijaUpdate>
    {
        Task<RezervacijaView> KreirajRezervacijuAsync(RezervacijaInsert novaRezervacija);
        Task<Dictionary<string, int>> BrojKupljenihKarataPoFilmuAsync(DateTime? datumOd, DateTime? datumDo);
        Task<Dictionary<string, int>> ZaradaOdFilmovaAsync(DateTime? datumOd, DateTime? datumDo);
        Task<Dictionary<string, int>> BrojProdatihKarataPoZanruAsync();
        Task OznaciRezervacijuKaoUslaAsync(int rezervacijaId);
        Task<List<RezervacijaView>> AktivneRezervacijeByKorisnikAsync(int id);
        Task<List<RezervacijaView>> NeaktivneRezervacijeByKorisnikAsync(int id);
    }
}
