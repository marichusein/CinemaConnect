using Microsoft.ML.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model
{
    
    public class FilmoviPreporuka
    {
        [KeyType(count: 100)]
        public uint FilmID { get; set; }
        [KeyType(count: 100)]
        public uint KorisnikID { get; set; }
        public float Ocjena { get; set; }
    }
}
