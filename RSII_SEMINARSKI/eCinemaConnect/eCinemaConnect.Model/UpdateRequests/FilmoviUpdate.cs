using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.UpdateRequests
{
    public class FilmoviUpdate
    {
        public string? NazivFilma { get; set; }

        public string? Opis { get; set; }

        public int? Trajanje { get; set; }

        public string? PlakatFilma { get; set; }
    }
}
