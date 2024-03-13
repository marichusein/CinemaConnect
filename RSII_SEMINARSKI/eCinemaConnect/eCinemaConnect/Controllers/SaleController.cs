using eCinemaConnect.Model;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using eCinemaConnect.Services;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinemaConnect.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class SaleController : ControllerBase
    {
        private readonly ISale _sale;

        public SaleController(ISale sale)
        {
            _sale = sale;
        }

        [HttpGet()]
        public async Task<IEnumerable<SalaView>> GetAsync()
        {
            return await _sale.GetAllAsync();
        }

        [HttpGet("{id}")]
        public async Task<SalaView> GetByIdAsync(int id)
        {
            return await _sale.GetObjAsync(id);
        }

        [HttpPost()]
        public async Task<SalaView> AddZanrAsync(SaleInsert obj)
        {
            return await _sale.AddObjAsync(obj);
        }

        [HttpPut("{id}")]
        public async Task<SalaView> UpdateSaluAsync(int id, SalaUpdate obj)
        {
            return await _sale.UpdateObjAsync(id, obj);
        }

        [HttpDelete("{id}")]
        public async Task<bool> DeleteAsync(int id)
        {
            return await _sale.DeleteByIdAsync(id);
        }
    }
}
