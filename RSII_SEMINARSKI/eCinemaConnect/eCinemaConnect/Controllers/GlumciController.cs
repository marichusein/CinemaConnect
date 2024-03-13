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
    public class GlumciController : ControllerBase
    {
        private readonly IGlumci _glumci;

        public GlumciController(IGlumci glumci)
        {
            _glumci = glumci;
        }

        [HttpGet()]
        public async Task<IEnumerable<GlumciView>> GetAsync()
        {
            return await _glumci.GetAllAsync();
        }

        [HttpGet("{id}")]
        public async Task<GlumciView> GetByIdAsync(int id)
        {
            return await _glumci.GetObjAsync(id);
        }

        [HttpGet("filmovibyglumacid/{Glumacid}")]
        public async Task<IEnumerable<FilmoviView>> GetByGlumacIdAsync(int Glumacid)
        {
            return await _glumci.VratiFilmoveZaGlumcaAsync(Glumacid);
        }

        [HttpPost()]
        public async Task<GlumciView> AddGlumcaAsync(GlumciInsert obj)
        {
            return await _glumci.AddObjAsync(obj);
        }

        [HttpPut("{id}")]
        public async Task<GlumciView> UpdateGlumcaAsync(int id, GlumciUpdate obj)
        {
            return await _glumci.UpdateObjAsync(id, obj);
        }

        [HttpDelete("{id}")]
        public async Task<bool> DeleteAsync(int id)
        {
            return await _glumci.DeleteByIdAsync(id);
        }
    }
}
