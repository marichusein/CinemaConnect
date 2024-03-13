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
    public class SjedisteService : BaseService<SjedistaView, SjedistaInsert, SjedistaUpdate, Sjedistum, Sjedistum>, ISjediste
    {
        private readonly CinemaContext _context;
        private readonly IMapper _mapper;

        public SjedisteService(CinemaContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<SjedistaView> AddSpecialAsync(SjedistaInsert sjedistaInsert)
        {
            var newS = new Database.Sjedistum();
            _mapper.Map(sjedistaInsert, newS);
            newS.Sala = await _context.Sales.FindAsync(sjedistaInsert.SalaId);
            _context.Add(newS);
            await _context.SaveChangesAsync();
            return _mapper.Map<SjedistaView>(newS);
        }

        public async Task<List<SjedistaView>> GetAllBySalaAsync(int id)
        {
            var entitiesWithInclude = await GetAllAsync(x => x.Sala);
            var poSali = entitiesWithInclude.Where(x => x.Sala.Idsale == id).ToList();
            return poSali;
        }

        public async Task<List<SjedistaView>> GetAllWithPovezanoSvojstvoAsync()
        {
            var entitiesWithInclude = await GetAllAsync(x => x.Sala);
            return entitiesWithInclude;
        }

        public async Task<SjedistaView> GetByIdAsync(int id)
        {
            var sve = await GetAllAsync(x => x.Sala);
            var rec = sve.FirstOrDefault(x => x.Idsjedista == id);
            return _mapper.Map<SjedistaView>(rec);
        }
    }
}
