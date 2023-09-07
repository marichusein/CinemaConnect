using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.ViewRequests
{
    public class FilmoviView
    {
        public int Idfilma { get; set; }

        public string? NazivFilma { get; set; }

        public ZanroviView? Zanr { get; set; }

        public string? Opis { get; set; }

        public int? Trajanje { get; set; }

        public int? GodinaIzdanja { get; set; }

        public ReziseriView? Reziser { get; set; }

        public byte[]? FilmPlakat { get; set; }
    }
}
