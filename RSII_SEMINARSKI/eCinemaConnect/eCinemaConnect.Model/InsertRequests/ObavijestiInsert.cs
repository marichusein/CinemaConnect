using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.InsertRequests
{
    public class ObavijestiInsert
    {
        
        public int? KorisnikId { get; set; }

        public string? Naslov { get; set; }

        public string? Sadrzaj { get; set; }

        public DateTime? DatumObjave { get; set; }

        public byte[]? Slika { get; set; }

        public DateTime? DatumUredjivanja { get; set; }
    }
}
