using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.ViewRequests
{
    public class RepertoarView
    {
        public int Idrepertoara { get; set; }

        public DateTime? Pocetak { get; set; }

        public DateTime? Kraj { get; set; }

        public string? Opis { get; set; }
    }
}
