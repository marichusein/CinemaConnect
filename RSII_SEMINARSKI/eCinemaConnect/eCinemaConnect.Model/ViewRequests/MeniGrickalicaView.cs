using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.ViewRequests
{
    public class MeniGrickalicaView
    {
        public int Idgrickalice { get; set; }

        public string? Naziv { get; set; }

        public string? Opis { get; set; }

        public decimal? Cijena { get; set; }

        public byte[]? Slika { get; set; }
    }
}
