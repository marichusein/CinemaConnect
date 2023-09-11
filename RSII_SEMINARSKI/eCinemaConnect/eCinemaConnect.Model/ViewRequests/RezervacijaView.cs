using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.ViewRequests
{
    public class RezervacijaView
    {
        public int Idrezervacije { get; set; }

        public int? KorisnikId { get; set; }

        public int? ProjekcijaId { get; set; }

        public int? BrojRezervisanihKarata { get; set; }

        public bool? Kupljeno { get; set; }
        public string? QRCode { get; set; }
        public List<SjedistaViewProjekcija>? odabranaSjedista { get; set; }
    }
}
