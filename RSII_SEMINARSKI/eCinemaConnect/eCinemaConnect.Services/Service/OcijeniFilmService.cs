using AutoMapper;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Service
{
    public class OcijeniFilmService : BaseService<OcijeniFilmView, OcijeniFilmInsert, OcijeniFilmUpdate, OcjeneIkomentari, OcjeneIkomentari>, IOcijeni
    {
        private readonly CinemaContext _context;
        private readonly IMapper _mapper;

        public OcijeniFilmService(CinemaContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<List<OcijeniFilmView>> GetKomentareZaFilmAsync(int idFilma)
        {
            var komentari = await _context.OcjeneIkomentaris.Where(x => x.FilmId == idFilma).ToListAsync();
            return _mapper.Map<List<OcijeniFilmView>>(komentari);
        }

        public async Task<double> GetProsjekZaFilmAsync(int idfilma)
        {
            var ocjene = await _context.OcjeneIkomentaris.Where(x => x.FilmId == idfilma).ToListAsync();
            var prosjek = ocjene.Average(x => x.Ocjena);
            if (prosjek.HasValue)
            {
                // Zaokruži prosjek na dvije decimale i pretvori ga u string
                var zaokruzeniProsjek = Math.Round((decimal)prosjek.Value, 2);
                return (double)zaokruzeniProsjek;
            }
            return 0.0;
        }
    }
}
