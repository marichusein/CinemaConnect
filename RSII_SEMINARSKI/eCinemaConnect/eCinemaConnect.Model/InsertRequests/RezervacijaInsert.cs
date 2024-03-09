using eCinemaConnect.Model.ViewRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.InsertRequests
{
    public class RezervacijaInsert
    {
        public int? KorisnikId { get; set; }

        public int? ProjekcijaId { get; set; }

        public int? BrojRezervisanihKarata { get; set; }

        public bool? Kupljeno { get; set; }
        public string? QRCode { get; set; }
        public List<SjedistaViewProjekcija>? odabranaSjedista { get; set; }
        public int? MeniGrickalica { get; set; }

    }
}
