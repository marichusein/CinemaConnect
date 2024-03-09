using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IRezervacije:IService<RezervacijaView, RezervacijaInsert, RezervacijaUpdate>
    {
        RezervacijaView KreirajRezervaciju(RezervacijaInsert novaRezervacija);
        public Dictionary<string, int> BrojKupljenihKarataPoFilmu(DateTime? datumOd, DateTime? datumDo);
        public Dictionary<string, int> ZaradaOdFilmova(DateTime? datumOd, DateTime? datumDo);
        public Dictionary<string, int> BrojProdatihKarataPoZanru();
        public void OznaciRezervacijuKaoUsla(int rezervacijaId);

    }
}
