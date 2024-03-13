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
    public class ReziseriController : ControllerBase
    {
        private readonly IReziser _reziser;

        public ReziseriController(IReziser reziser)
        {
            _reziser = reziser;
        }

        [HttpGet()]
        public async Task<IEnumerable<ReziseriView>> GetAsync()
        {
            return await _reziser.GetAllAsync();
        }

        [HttpGet("{id}")]
        public async Task<ReziseriView> GetByIdAsync(int id)
        {
            return await _reziser.GetObjAsync(id);
        }

        [HttpPost()]
        public async Task<ReziseriView> AddReziseraAsync(ReziserInsert obj)
        {
            return await _reziser.AddObjAsync(obj);
        }


        [HttpPut("{id}")]
        public async Task<ReziseriView> UpdateReziseraAsync(int id, ReziserUpdate obj)
        {
            return await _reziser.UpdateObjAsync(id, obj);
        }

        [HttpDelete("{id}")]
        public async Task<bool> DeleteAsync(int id)
        {
            return await _reziser.DeleteByIdAsync(id);
        }
    }
}
