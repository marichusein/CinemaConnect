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
    public class KomentariObavijestiService : BaseService<KomentariObavijestiView, KomentariObavijestiInsert, KomentariObavijestiUpdate, KomentariObavijesti, KomentariObavijesti>, IKomentariObavijesti
    {
        CinemaContext _context;
        IMapper _mapper;
        public KomentariObavijestiService(CinemaContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
            _mapper=mapper;
        }

        public async Task<List<KomentariObavijestiView>> getByObavijestAsync(int obavijestId)
        {
            var komentari = await _context.KomentariObavijestis.Where(x => x.ObavijestId == obavijestId).ToListAsync();
            return _mapper.Map<List<KomentariObavijestiView>>(komentari);
        }
    }
}
