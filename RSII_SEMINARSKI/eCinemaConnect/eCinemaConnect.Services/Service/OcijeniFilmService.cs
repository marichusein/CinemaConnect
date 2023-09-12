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
        IMapper _mapper;
        public OcijeniFilmService(CinemaContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public List<OcijeniFilmView> GetKomentareZaFilm(int idFilma)
        {
           var komentaru=_context.OcjeneIkomentaris.Where(x=>x.FilmId== idFilma).ToList();
           return _mapper.Map<List<OcijeniFilmView>>(komentaru);
            
        }

        public double getProsjekZaFilm(int idfilma)
        {
            var ocjene = _context.OcjeneIkomentaris.Where(x => x.FilmId == idfilma);
            var prosjek = ocjene.Average(x => x.Ocjena);
            if (prosjek != null)
            {
                // Zaokruži prosjek na dvije decimale i pretvori ga u string
                var zaokruzeniProsjek = Math.Round((decimal)prosjek, 2).ToString("0.00");
                return double.Parse(zaokruzeniProsjek);
            }
            return 0.0;
        }
    }
}
