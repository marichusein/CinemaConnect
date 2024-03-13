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
    public class OcijeniFilmController : ControllerBase
    {
        private readonly IOcijeni _ocijeni;

        public OcijeniFilmController(IOcijeni ocjeni)
        {
            _ocijeni = ocjeni;
        }

        [HttpGet]
        public async Task<IEnumerable<OcijeniFilmView>> GetAsync()
        {
            return await _ocijeni.GetAllAsync();
        }

        [HttpGet("{id}")]
        public async Task<OcijeniFilmView> GetByIdAsync(int id)
        {
            return await _ocijeni.GetObjAsync(id);
        }

        [HttpGet("film/{id}")]
        public async Task<List<OcijeniFilmView>> GetByIdFilmAsync(int id)
        {
            return await _ocijeni.GetKomentareZaFilmAsync(id);
        }

        [HttpPost]
        public async Task<OcijeniFilmView> AddGlumcaAsync(OcijeniFilmInsert obj)
        {
            return await _ocijeni.AddObjAsync(obj);
        }

        [HttpPut("{id}")]
        public async Task<OcijeniFilmView> UpdateGlumcaAsync(int id, OcijeniFilmUpdate obj)
        {
            return await _ocijeni.UpdateObjAsync(id, obj);
        }

        [HttpDelete("{id}")]
        public async Task<bool> DeleteAsync(int id)
        {
            return await _ocijeni.DeleteByIdAsync(id);
        }

        [HttpGet("/film")]
        public async Task<double> GetOcjenuAsync(int id)
        {
            return await _ocijeni.GetProsjekZaFilmAsync(id);
        }
    }
}
