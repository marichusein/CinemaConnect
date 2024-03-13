using AutoMapper;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Service
{
    public class RecenzijeService : BaseService<RecenzijeView, RecenzijeInsert, RecenzijeUpdate, Recenzije, Recenzije>, IRecenzije
    {
        private readonly CinemaContext _context;
        private readonly IMapper _mapper;

        public RecenzijeService(CinemaContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
            _mapper = mapper;
            
        }

        public async Task<List<RecenzijeView>> GetAllWithPovezanoSvojstvoAsync()
        {
            var entitiesWithInclude = await GetAllAsync(x => x.Film);
            return entitiesWithInclude;
        }

        public async Task<RecenzijeView> GetByIdAsync(int id)
        {
            var sve = await GetAllAsync(x => x.Film);
            var rec = sve.FirstOrDefault(x => x.Idrecenzije == id);
            return _mapper.Map<RecenzijeView>(rec);
        }

        public async Task<RecenzijeView> AddRecenzijuAsync(RecenzijeInsert recenzijeInsert)
        {
            var newRecenzija = new Database.Recenzije();
            _mapper.Map(recenzijeInsert, newRecenzija);
            newRecenzija.Film = await _context.Filmovis.FindAsync(recenzijeInsert.FilmId);
            _context.Add(newRecenzija);
            await _context.SaveChangesAsync();
            return _mapper.Map<RecenzijeView>(newRecenzija);
        }
    }
}
