using eCinemaConnect.Model.ViewRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.InsertRequests
{
    public class FilmoviInsert
    {
        public string? NazivFilma { get; set; }

        public int? ZanrId { get; set; }

        public string? Opis { get; set; }

        public int? Trajanje { get; set; }

        public int? GodinaIzdanja { get; set; }

        public int? ReziserId { get; set; }
        public byte[]? FilmPlakat { get; set; }

        // public string? PlakatFilma { get; set; }
        public List<GlumciView>? glumciUFlimu { get; set; }
    }
}
