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
    public class SaleService : ISale
    {
        CinemaContext _context;
        public IMapper _mapper { get; set; }

        public SaleService(CinemaContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public SalaView AddSalu(SaleInsert salaInsert)
        {
            var newSala = new Database.Sale();
            _mapper.Map(salaInsert, newSala);
            _context.Add(newSala);
            _context.SaveChanges();

            return _mapper.Map<SalaView>(newSala);
        }

        public bool DeleteById(int id)
        {
            var objektIzBaze = _context.Sales.Find(id);

            if (objektIzBaze != null)
            {
                _context.Sales.Remove(objektIzBaze);
                _context.SaveChanges();
                return true;
            }

            return false;
        }

        public List<SalaView> GetAll()
        {
            var sale = _context.Sales.ToList();
            return _mapper.Map<List<SalaView>>(sale);
        }

        public SalaView GetById(int id)
        {
            var sala = _context.Sales.Find(id);
            return _mapper.Map<SalaView>(sala);
        }

        public SalaView UpdateSalu(int id, SalaUpdate salaUpdate)
        {
            var existingSala = _context.Sales.Find(id);
            if (existingSala != null)
            {
                _mapper.Map(salaUpdate, existingSala);
                _context.SaveChanges();
                return _mapper.Map<SalaView>(existingSala);
            }
            return null;
        }
    }
}
