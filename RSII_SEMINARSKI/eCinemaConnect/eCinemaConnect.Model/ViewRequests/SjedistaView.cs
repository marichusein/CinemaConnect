using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.ViewRequests
{
    public class SjedistaView
    {
        public int Idsjedista { get; set; }

        public int? BrojSjedista { get; set; }

        public SalaView Sala { get; set; }
    }
}
