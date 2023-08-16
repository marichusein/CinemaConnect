using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.ViewRequests
{
    public class RecenzijeView
    {
        public int Idrecenzije { get; set; }

        public string? NaslovRecenzije { get; set; }

        public string? SadrzajRecenzije { get; set; }

        public DateTime? DatumObjave { get; set; }

        public FilmoviView Film { get; set; }
    }
}
