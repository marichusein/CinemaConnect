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
    public class GlumciService : IGlumci
    {

        CinemaContext _context;
        public IMapper _mapper { get; set; }

        public GlumciService(CinemaContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public GlumciView AddGlumca(GlumciInsert glumciInsert)
        {
            var newGlumac = new Database.Glumci();
            _mapper.Map(glumciInsert, newGlumac);
            _context.Add(newGlumac);
            _context.SaveChanges();

            return _mapper.Map<GlumciView>(newGlumac);
        }

        public bool DeleteById(int id)
        {
            var glumacToDelete = _context.Glumcis.Find(id);

            if (glumacToDelete == null)
                return false;

            _context.Glumcis.Remove(glumacToDelete);
            _context.SaveChanges();

            return true;
        }

        public List<GlumciView> GetAll()
        {
            var glumci = _context.Glumcis.ToList();
            return _mapper.Map<List<GlumciView>>(glumci);
        }

        public GlumciView UpdateGlumca(int id, GlumciUpdate glumciUpdate)
        {
            var existingGlumac = _context.Glumcis.Find(id);

            if (existingGlumac == null)
                throw new Exception("Greška");

            _mapper.Map(glumciUpdate, existingGlumac);
            _context.SaveChanges();

            return _mapper.Map<GlumciView>(existingGlumac);
        }
    }
}
