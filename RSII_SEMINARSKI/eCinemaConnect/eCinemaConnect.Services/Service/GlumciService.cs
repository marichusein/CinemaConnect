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
    public class GlumciService : BaseService<GlumciView, GlumciInsert, GlumciUpdate, Glumci, Glumci>, IGlumci
    {
        private readonly CinemaContext _context;
        private readonly IMapper _mapper;
        public GlumciService(CinemaContext context, IMapper mapper) : base(context, mapper)
        {
            _context= context;
            _mapper= mapper;
        }

        public IEnumerable<FilmoviView> VratiFilmoveZaGlumca(int glumacId)
        {
            var filmoviZaGlumca = _context.Glumcis
                .Where(g => g.Idglumca == glumacId)
                .SelectMany(g => g.GlumciFilmovis)
                .Select(gf => gf.Film); // Pretpostavljajući da postoji navigacijsko svojstvo 'Film' u entitetu 'GlumciFilmovi'

            var filmoviViewZaGlumca = _mapper.Map<IEnumerable<Filmovi>, IEnumerable<FilmoviView>>(filmoviZaGlumca);
            return filmoviViewZaGlumca;
        }
    }
}
