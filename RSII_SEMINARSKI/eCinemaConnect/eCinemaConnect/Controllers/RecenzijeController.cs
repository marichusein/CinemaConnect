using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
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

    public class RecenzijeController : ControllerBase
    {
        private readonly IRecenzije _basic;

        public RecenzijeController(IRecenzije basic)
        {
            _basic = basic;
        }

        [HttpGet]
        public async Task<IEnumerable<RecenzijeView>> GetAsync()
        {
            return await _basic.GetAllWithPovezanoSvojstvoAsync();
        }

        [HttpGet("{id}")]
        public async Task<RecenzijeView> GetByIdAsync(int id)
        {
            return await _basic.GetByIdAsync(id);
        }

        [HttpPost]
        public async Task<RecenzijeView> AddMenuAsync(RecenzijeInsert obj)
        {
            return await _basic.AddRecenzijuAsync(obj);
        }

        [HttpPut("{id}")]
        public async Task<RecenzijeView> UpdateMenuAsync(int id, RecenzijeUpdate obj)
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
