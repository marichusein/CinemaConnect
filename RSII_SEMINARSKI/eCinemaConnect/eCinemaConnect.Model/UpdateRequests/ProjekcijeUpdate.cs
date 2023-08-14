using eCinemaConnect.Model.ViewRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.UpdateRequests
{
    public class ProjekcijeUpdate
    {
        public DateTime? DatumVrijemeProjekcije { get; set; }

        public decimal? CijenaKarte { get; set; }

    }
}
