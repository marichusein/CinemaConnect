using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.ViewRequests
{
    public class OcijeniFilmView
    {
        public int Idocjene { get; set; }
        public int? KorisnikId { get; set; }

        public int? FilmId { get; set; }

        public int? Ocjena { get; set; }

        public string? Komentar { get; set; }

        public DateTime? DatumOcjene { get; set; }
    }
}
