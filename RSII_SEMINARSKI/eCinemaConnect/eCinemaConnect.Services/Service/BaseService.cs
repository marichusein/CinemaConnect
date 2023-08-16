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
    public class BaseService<T, TInsert, TUpdate, TDBx, TDataBase> : IService<T, TInsert, TUpdate> where T : class where TInsert : class where TUpdate : class where TDBx : class where TDataBase : class, new()
    {
        CinemaContext _context;
        public IMapper _mapper { get; set; }
        public BaseService(CinemaContext context, IMapper mapper) 
        {
            _context = context;
            _mapper = mapper;
        }

        public List<T> GetAll()
        {
            var obj = _context.Set<TDBx>().AsQueryable().ToList();
            return _mapper.Map<List<T>>(obj);
        }

        public T AddObj(TInsert Insert)
        {
            var newObj = new TDataBase();
            _mapper.Map(Insert, newObj);
            _context.Add(newObj);
            _context.SaveChanges();

            return _mapper.Map<T>(newObj);
        }

        public T UpdateObj(int id, TUpdate Update)
        {
            var existing = _context.Set<TDBx>().Find(id);
            if (existing != null)
            {
                _mapper.Map(Update, existing);
                _context.SaveChanges();
                return _mapper.Map<T>(existing);
            }
            return null;
        }

        public T GetObj(int id)
        {
            var obj = _context.Set<TDBx>().Find(id);
            return _mapper.Map<T>(obj);
        }

        public bool DeleteById(int id)
        {
            var objektIzBaze = _context.Set<TDBx>().Find(id);

            if (objektIzBaze != null)
            {
                _context.Set<TDBx>().Remove(objektIzBaze);
                _context.SaveChanges();
                return true;
            }

            return false;
        }
    }
}
