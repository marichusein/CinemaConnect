using AutoMapper;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Service
{
    public class OcijeniFilmService : BaseService<OcijeniFilmView, OcijeniFilmInsert, OcijeniFilmUpdate, OcjeneIkomentari, OcjeneIkomentari>, IOcijeni
    {
        CinemaContext _context;
        public OcijeniFilmService(CinemaContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        public double getProsjekZaFilm(int idfilma)
        {
            var ocjene = _context.OcjeneIkomentaris.Where(x => x.FilmId == idfilma);
            var prosjek = ocjene.Average(x => x.Ocjena);
            if (prosjek != null)
            {
                return (double)prosjek;
            }
            return 0.0;
        }
    }
}
