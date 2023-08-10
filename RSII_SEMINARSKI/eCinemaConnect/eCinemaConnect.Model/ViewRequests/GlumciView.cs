using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.ViewRequests
{
    public class GlumciView
    {
        public int Idglumca { get; set; }

        public string? Ime { get; set; }

        public string? Prezime { get; set; }

        public byte[]? Slika { get; set; }
    }
}
