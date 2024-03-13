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
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Service
{
    public class BaseService<T, TInsert, TUpdate, TDBx, TDataBase> : IService<T, TInsert, TUpdate> where T : class where TInsert : class where TUpdate : class where TDBx : class where TDataBase : class, new()
    {
        private readonly CinemaContext _context;
        private readonly IMapper _mapper;

        public BaseService(CinemaContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<List<T>> GetAllAsync(params Expression<Func<T, object>>[] includeProperties)
        {
            IQueryable<TDBx> query = _context.Set<TDBx>();

            foreach (var includeExpression in includeProperties)
            {
                string propertyName = (includeExpression.Body as MemberExpression)?.Member.Name;
                if (!string.IsNullOrEmpty(propertyName))
                {
                    query = query.Include(propertyName);
                }
            }

            var obj = await query.ToListAsync();
            return _mapper.Map<List<T>>(obj);
        }

        public async Task<T> AddObjAsync(TInsert Insert)
        {
            var newObj = new TDataBase();
            _mapper.Map(Insert, newObj);
            _context.Add(newObj);
            await _context.SaveChangesAsync();

            return _mapper.Map<T>(newObj);
        }

        public async Task<T> UpdateObjAsync(int id, TUpdate Update)
        {
            var existing = await _context.Set<TDBx>().FindAsync(id);
            if (existing != null)
            {
                _mapper.Map(Update, existing);
                await _context.SaveChangesAsync();
                return _mapper.Map<T>(existing);
            }
            return null;
        }

        public async Task<T> GetObjAsync(int id)
        {
            var obj = await _context.Set<TDBx>().FindAsync(id);
            return _mapper.Map<T>(obj);
        }

        public async Task<bool> DeleteByIdAsync(int id)
        {
            var objektIzBaze = await _context.Set<TDBx>().FindAsync(id);

            if (objektIzBaze != null)
            {
                _context.Set<TDBx>().Remove(objektIzBaze);
                await _context.SaveChangesAsync();
                return true;
            }

            return false;
        }
    }
}
