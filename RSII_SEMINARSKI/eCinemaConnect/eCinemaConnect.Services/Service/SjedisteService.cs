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
    public class SjedisteService : BaseService<SjedistaView, SjedistaInsert, SjedistaUpdate, Sjedistum, Sjedistum>, ISjediste
    {
        CinemaContext _context;
        public SjedisteService(CinemaContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        public SjedistaView AddSpecial(SjedistaInsert sjedistaInsert)
        {
            var newS = new Database.Sjedistum();
            _mapper.Map(sjedistaInsert, newS);
            newS.Sala = _context.Sales.Find(sjedistaInsert.SalaId);
            _context.Add(newS);
            _context.SaveChanges();
            return _mapper.Map<SjedistaView>(newS);
        }

        public List<SjedistaView> GetAllBySala(int id)
        {

            var entitiesWithInclude = GetAll(x => x.Sala);
            var poSali = entitiesWithInclude.Where(x => x.Sala.Idsale == id).ToList();

            return poSali;
        }

        public List<SjedistaView> GetAllWithPovezanoSvojstvo()
        {
            var entitiesWithInclude = GetAll(x => x.Sala);

            return entitiesWithInclude;
        }

        public SjedistaView GetById(int id)
        {
            var sve = GetAll(x => x.Sala);
            var rec = sve.Where(x => x.Idsjedista == id).FirstOrDefault();
            return _mapper.Map<SjedistaView>(rec);
        }
    }
}
