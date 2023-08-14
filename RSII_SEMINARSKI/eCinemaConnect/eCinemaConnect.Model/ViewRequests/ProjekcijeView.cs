using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.ViewRequests
{
    public class ProjekcijeView
    {
        public int Idprojekcije { get; set; }

        public DateTime? DatumVrijemeProjekcije { get; set; }

        public decimal? CijenaKarte { get; set; }

        public virtual FilmoviView? Film { get; set; }

        public virtual SalaView? Sala { get; set; }
    }
}
