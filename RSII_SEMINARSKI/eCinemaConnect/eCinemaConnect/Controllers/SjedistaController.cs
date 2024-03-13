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
    public class SjedistaController : ControllerBase
    {
        private readonly ISjediste _basic;

        public SjedistaController(ISjediste basic)
        {
            _basic = basic;
        }

        [HttpGet()]
        public async Task<IEnumerable<SjedistaView>> GetAsync()
        {
            return await _basic.GetAllWithPovezanoSvojstvoAsync();
        }

        [HttpGet("{id}")]
        public async Task<SjedistaView> GetByIdAsync(int id)
        {
            return await _basic.GetByIdAsync(id);
        }

        [HttpGet("sala/{id}")]
        public async Task<IEnumerable<SjedistaView>> GetBySAlaAsync(int id)
        {
            return await _basic.GetAllBySalaAsync(id);
        }

        [HttpPost()]
        public async Task<SjedistaView> AddMenuAsync(SjedistaInsert obj)
        {
            return await _basic.AddSpecialAsync(obj);
        }

        [HttpPut("{id}")]
        public async Task<SjedistaView> UpdateMenuAsync(int id, SjedistaUpdate obj)
        {
            return await _basic.UpdateObjAsync(id, obj);
        }

        [HttpDelete("{id}")]
        public async Task<bool> DeleteAsync(int id)
        {
            return await _basic.DeleteByIdAsync(id);
        }
    }
}
