using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.UpdateRequests
{
    public class KorisniciUpdate
    {
        public string? Ime { get; set; }

        public string? Prezime { get; set; }
        public string? KorisnickoIme { get; set; }

        public string? Lozinka { get; set; }

        public string? Email { get; set; }

        public string? Telefon { get; set; }

    }
}
