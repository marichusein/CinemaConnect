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
    public class RecenzijeService : BaseService<RecenzijeView, RecenzijeInsert, RecenzijeUpdate, Recenzije, Recenzije>, IRecenzije
    {
        CinemaContext _context;
        public RecenzijeService(CinemaContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }
        public List<RecenzijeView> GetAllWithPovezanoSvojstvo()
        {
            var entitiesWithInclude = GetAll(x => x.Film);

            return entitiesWithInclude;
        }
        public RecenzijeView GetById(int id)
        {
            var sve= GetAll(x => x.Film);
            var rec = sve.Where(x => x.Idrecenzije == id).FirstOrDefault();
            return _mapper.Map<RecenzijeView>(rec);
        }
        public RecenzijeView AddRecenziju(RecenzijeInsert recenzijeInsert)
        {
            var newRecenzija = new Database.Recenzije();
            _mapper.Map(recenzijeInsert, newRecenzija);
            newRecenzija.Film = _context.Filmovis.Find(recenzijeInsert.FilmId);
            _context.Add(newRecenzija);
            _context.SaveChanges();
            return _mapper.Map<RecenzijeView>(newRecenzija);
        }
    }
}
