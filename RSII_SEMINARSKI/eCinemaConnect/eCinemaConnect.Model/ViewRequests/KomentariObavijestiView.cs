using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.ViewRequests
{
    public class KomentariObavijestiView
    {
        public int Id { get; set; }

        public int? ObavijestId { get; set; }

        public int? KorisnikId { get; set; }

        public string? TekstKomentara { get; set; }

        public DateTime? DatumKomentara { get; set; }
    }
}
