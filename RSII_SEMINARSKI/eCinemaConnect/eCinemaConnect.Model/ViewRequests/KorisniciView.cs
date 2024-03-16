using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.ViewRequests
{
    public class KorisniciView
    {
        public int Idkorisnika { get; set; }

        public string? Ime { get; set; }

        public string? Prezime { get; set; }

        public string? KorisnickoIme { get; set; }
        public string? Email { get; set; }
        public string? Token { get; set; }
        public string? Telefon { get; set; }

        public TipGledatelja Tip { get; set; }



    }
}
