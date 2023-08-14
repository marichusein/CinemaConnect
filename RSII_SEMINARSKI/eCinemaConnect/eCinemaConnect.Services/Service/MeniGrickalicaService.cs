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
    public class MeniGrickalicaService : IMeniGrickalica
    {
        CinemaContext _context;
        public IMapper _mapper { get; set; }
        public MeniGrickalicaService(CinemaContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public MeniGrickalicaView AddMeni(MeniGrickalicaInsert meniInsert)
        {
            var newMeni = new Database.MeniGrickalica();
            _mapper.Map(meniInsert, newMeni);
            _context.Add(newMeni);
            _context.SaveChanges();

            return _mapper.Map<MeniGrickalicaView>(newMeni);
        }

        public bool DeleteById(int id)
        {
            var objektIzBaze = _context.MeniGrickalicas.Find(id);

            if (objektIzBaze != null)
            {
                _context.MeniGrickalicas.Remove(objektIzBaze);
                _context.SaveChanges();
                return true;
            }

            return false;
        }

        public List<MeniGrickalicaView> GetAll()
        {
            var meniGrickalicas = _context.MeniGrickalicas.ToList();
            return _mapper.Map<List<MeniGrickalicaView>>(meniGrickalicas);
        }

        public MeniGrickalicaView GetById(int id)
        {
            var meni = _context.MeniGrickalicas.Find(id);
            return _mapper.Map<MeniGrickalicaView>(meni);
        }

        public MeniGrickalicaView UpdateMeni(int id, MeniGrickalicaUpdate meniUpdate)
        {
            var existingMeni = _context.MeniGrickalicas.Find(id);
            if (existingMeni != null)
            {
                _mapper.Map(meniUpdate, existingMeni);
                _context.SaveChanges();
                return _mapper.Map<MeniGrickalicaView>(existingMeni);
            }
            return null;
        }
    }
}
