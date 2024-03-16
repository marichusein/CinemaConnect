using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.ViewRequests
{
    public class RecommenderView
    {
        public int FilmId { get; set; }
        public int CoFilmId1 { get; set; }
        public int CoFilmId2 { get; set; }
        public int CoFilmId3 { get; set; }
    }
}
