using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.UpdateRequests
{
    public class OcijeniFilmUpdate
    {
    
        public int? Ocjena { get; set; }

        public string? Komentar { get; set; }

        public DateTime? DatumOcjene { get; set; }
    }
}
