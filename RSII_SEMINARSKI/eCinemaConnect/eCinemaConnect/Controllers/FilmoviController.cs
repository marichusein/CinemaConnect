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
    public class FilmoviController : ControllerBase
    {
        private readonly IFilmovi _filmovi;
        private readonly IRecommender _preporuka;


        public FilmoviController(IFilmovi filmovi, IRecommender preporuka)
        {
            _filmovi = filmovi;
            _preporuka = preporuka;
        }

        [HttpGet()]
        public async Task<IEnumerable<FilmoviView>> Get()
        {
            return await _filmovi.GetAll();
        }

        [HttpGet("sve")]
        public async Task<IEnumerable<FilmoviView>> GetAll()
        {
            return await _filmovi.GetSve();
        }

        [HttpGet("zanr/{zanrid}")]
        public async Task<IEnumerable<FilmoviView>> GetByZanr(int zanrid)
        {
            return await _filmovi.GetFilmoviByZanr(zanrid);
        }

        [HttpGet("glumac/{glumacid}")]
        public async Task<IEnumerable<FilmoviView>> GetByGlumac(int glumacid)
        {
            return await _filmovi.GetFilmoviByGlumac(glumacid);
        }

        [HttpGet("reziser/{reziserid}")]
        public async Task<IEnumerable<FilmoviView>> GetByReziser(int reziserid)
        {
            return await _filmovi.GetFilmoviByReziser(reziserid);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<FilmoviView>> GetById(int id)
        {
            var film = await _filmovi.GetById(id);
            if (film == null)
            {
                return NotFound();
            }
            return film;
        }

        [HttpPost()]
        public async Task<ActionResult<FilmoviView>> AddFilmovi(FilmoviInsert obj)
        {
            var film = await _filmovi.AddFilm(obj);
            return CreatedAtAction(nameof(GetById), new { id = film.Idfilma }, film);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateFilma(int id, FilmoviUpdate obj)
        {
            

            var updatedFilm = await _filmovi.UpdateFilma(id, obj);

            if (updatedFilm == null)
            {
                return NotFound();
            }

            return Ok();
        }

        [HttpGet("filter/multiple")]
        public async Task<IEnumerable<FilmoviView>> GetByMultipleFilters(int? zanrid, int? glumacid, int? reziserid)
        {
            return await _filmovi.GetFilmoviByMultipleFilters(zanrid, glumacid, reziserid);
        }

        [HttpGet("preporuka")]
        public async Task< List<FilmoviView>> GetPreporuka(int korisnikid)
        {
            return await _filmovi.GetPreprukuByKorisnikID(korisnikid);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var success = await _filmovi.IzbirsiFilm(id);
            if (!success)
            {
                return NotFound();
            }

            return NoContent();
        }

        [HttpPut("aktiviraj/{id}")]
        public async Task<IActionResult> Aktiviraj(int id)
        {
            var success = await _filmovi.AktivirajFilm(id);
            if (!success)
            {
                return NotFound();
            }

            return NoContent();
        }
    }
}
