using eCinemaConnect.Model.ViewRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.InsertRequests
{
    public class ProjekcijeInsert
    {
        public int? FilmId { get; set; }

        public int? SalaId { get; set; }

        public DateTime? DatumVrijemeProjekcije { get; set; }

        public decimal? CijenaKarte { get; set; }

    }
}
