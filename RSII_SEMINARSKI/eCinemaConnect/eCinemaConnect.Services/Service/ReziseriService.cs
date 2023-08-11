using AutoMapper;
using eCinemaConnect.Model;
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
    public class ReziseriService : IReziser
    {
        CinemaContext _context;
        public IMapper _mapper { get; set; }

        public ReziseriService(CinemaContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public ReziseriView AddRezisera(ReziserInsert reziserInsert)
        {
            var newReziser = new Database.Reziseri();
            _mapper.Map(reziserInsert, newReziser);
            _context.Add(newReziser);
            _context.SaveChanges();

            return _mapper.Map<ReziseriView>(newReziser);
        }

        public bool DeleteById(int id)
        {
            var objektIzBaze = _context.Reziseris.Find(id);

            if (objektIzBaze != null)
            {
                _context.Reziseris.Remove(objektIzBaze);
                _context.SaveChanges();
                return true;
            }

            return false;
        }

        public List<ReziseriView> GetAll()
        {
            return _mapper.Map<List<Model.ViewRequests.ReziseriView>>(_context.Reziseris.ToList());
        }

        public ReziseriView UpdateRezisera(int id, ReziserUpdate reziserUpdate)
        {
            var objektIzBaze = _context.Reziseris.Find(id);
            _mapper.Map(reziserUpdate, objektIzBaze);
            _context.SaveChanges();
            return _mapper.Map<Model.ViewRequests.ReziseriView>(objektIzBaze);
        }

        public ReziseriView GetById(int id)
        {
            var objektIzBaze = _context.Reziseris.Find(id);
            if(objektIzBaze != null)
            {
                return _mapper.Map<Model.ViewRequests.ReziseriView>(objektIzBaze);
            }
            return new ReziseriView();
        }
    }
}
