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
    public class ZanroviController : ControllerBase
    {
        private readonly IZanrovi _zanrovi;

        public ZanroviController(IZanrovi zanrovi)
        {
            _zanrovi = zanrovi;
        }

        [HttpGet()]
        public async Task<IEnumerable<ZanroviView>> GetAsync()
        {
            return await _zanrovi.GetAllAsync();
        }

        [HttpGet("{id}")]
        public async Task<ZanroviView> GetByIdAsync(int id)
        {
            return await _zanrovi.GetObjAsync(id);
        }

        [HttpPost()]
        public async Task<ZanroviView> AddZanrAsync(ZanroviInsert obj)
        {
            return await _zanrovi.AddObjAsync(obj);
        }

        [HttpPut("{id}")]
        public async Task<ZanroviView> UpdateZanrAsync(int id, ZanroviUpdate obj)
        {
            return await _zanrovi.UpdateObjAsync(id, obj);
        }

        [HttpDelete("{id}")]
        public async Task<bool> DeleteAsync(int id)
        {
            return await _zanrovi.DeleteByIdAsync(id);
        }
    }
}
