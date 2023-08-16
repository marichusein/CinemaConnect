using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.InsertRequests
{
    public class RecenzijeInsert
    {
        public int? FilmId { get; set; }

        public string? NaslovRecenzije { get; set; }

        public string? SadrzajRecenzije { get; set; }

        public DateTime? DatumObjave { get; set; }

    }
}
