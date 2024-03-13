using eCinemaConnect.Model;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using eCinemaConnect.Services;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinemaConnect.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class ProjekcijeController : ControllerBase
    {
        private readonly IProjekcije _projekcije;

        public ProjekcijeController(IProjekcije projekcije)
        {
            _projekcije = projekcije;
        }

        [HttpGet()]
        public async Task<IEnumerable<ProjekcijeView>> GetAsync()
        {
            return await _projekcije.GetAllAsync();
        }

        [HttpGet("aktivne")]
        public async Task<IEnumerable<ProjekcijeView>> GetAktivneAsync()
        {
            return await _projekcije.GetAktivneProjekcijeAsync();
        }

        [HttpGet("film/{filmId}")]
        public async Task<IEnumerable<ProjekcijeView>> GetByFilmAsync(int filmId)
        {
            return await _projekcije.GetByFilmAsync(filmId);
        }

        [HttpGet("film/aktivne/{filmId}")]
        public async Task<IEnumerable<ProjekcijeView>> GetByFilmAktivneAsync(int filmId)
        {
            return await _projekcije.GetByFilmAktivneAsync(filmId);
        }

        [HttpGet("{id}")]
        public async Task<ProjekcijeView> GetByIdAsync(int id)
        {
            return await _projekcije.GetByIdAsync(id);
        }

        [HttpGet("sjedista/{projekcijaID}")]
        public async Task<List<SjedistaViewProjekcija>> GetSjedistaByIdAsync(int projekcijaID)
        {
            return await _projekcije.GetSjedistaByProjekcijaAsync(projekcijaID);
        }

        [HttpPost()]
        public async Task<IActionResult> AddProjekcijuAsync(ProjekcijeInsert obj)
        {
            try
            {
                var projekcija = await _projekcije.AddProjekcijuAsync(obj);
                return Ok(projekcija);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPut("{id}")]
        public async Task<ProjekcijeView> UpdateProjekcijuAsync(int id, ProjekcijeUpdate obj)
        {
            return await _projekcije.UpdateProjekcijuAsync(id, obj);
        }

        [HttpDelete("{id}")]
        public async Task<bool> DeleteAsync(int id)
        {
            return await _projekcije.DeleteByIdAsync(id);
        }
    }
}
