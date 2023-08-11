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
    public class ZanroviService : IZanrovi
    {
        CinemaContext _context;
        public IMapper _mapper { get; set; }
        public ZanroviService(CinemaContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        ZanroviView IZanrovi.AddZanr(ZanroviInsert zanroviInsert)
        {
            var newZanr = new Database.Zanrovi();
            _mapper.Map(zanroviInsert, newZanr);
            _context.Add(newZanr);
            _context.SaveChanges();

            return _mapper.Map<ZanroviView>(newZanr);
        }

        bool IZanrovi.DeleteById(int id)
        {
            var objektIzBaze = _context.Zanrovis.Find(id);

            if (objektIzBaze != null)
            {
                _context.Zanrovis.Remove(objektIzBaze);
                _context.SaveChanges();
                return true;
            }

            return false;
        }

        List<ZanroviView> IZanrovi.GetAll()
        {
            var zanrovi = _context.Zanrovis.ToList();
            return _mapper.Map<List<ZanroviView>>(zanrovi);
        }

        ZanroviView IZanrovi.GetById(int id)
        {
            var zanr = _context.Zanrovis.Find(id);
            return _mapper.Map<ZanroviView>(zanr);
        }

        ZanroviView IZanrovi.UpdateZanr(int id, ZanroviUpdate zanroviUpdate)
        {
            var existingZanr = _context.Zanrovis.Find(id);
            if (existingZanr != null)
            {
                _mapper.Map(zanroviUpdate, existingZanr);
                _context.SaveChanges();
                return _mapper.Map<ZanroviView>(existingZanr);
            }
            return null;
        }
    }
}
