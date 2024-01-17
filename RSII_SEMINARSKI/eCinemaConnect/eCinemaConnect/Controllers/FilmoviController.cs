using eCinemaConnect.Model;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Services;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using Microsoft.AspNetCore.Authorization;
//using eCinemaConnect.Services.Database;
using Microsoft.AspNetCore.Mvc;

namespace eCinemaConnect.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class FilmoviController : ControllerBase
    {
        private readonly IFilmovi _filmovi;

        public FilmoviController(IFilmovi filmovi)
        {
            _filmovi = filmovi;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.FilmoviView> Get()
        {
            return _filmovi.GetAll();
        }

        [HttpGet("zanr/{zanrid}")]
        public IEnumerable<Model.ViewRequests.FilmoviView> GetByZanr(int zanrid)
        {
            return _filmovi.GetFilmoviByZanr(zanrid);
        }
        [HttpGet("glumac/{glumacid}")]
        public IEnumerable<Model.ViewRequests.FilmoviView> GetByGlumac(int glumacid)
        {
            return _filmovi.GetFilmoviByGlumac(glumacid);
        }
        [HttpGet("reziser/{reziserid}")]
        public IEnumerable<Model.ViewRequests.FilmoviView> GetByreziser(int reziserid)
        {
            return _filmovi.GetFilmoviByReziser(reziserid);
        }
        [HttpGet("{id}")]
        public Model.ViewRequests.FilmoviView GetById(int id)
        {
            return _filmovi.GetById(id);
        }

        [HttpPost()]
        public Model.ViewRequests.FilmoviView AddFilmovi(FilmoviInsert obj)
        {
            return _filmovi.AddFilm(obj);
        }

        [HttpPut("{id}")]
        public Model.ViewRequests.FilmoviView UpdateFilma(int id, FilmoviUpdate obj)
        {
            return _filmovi.UpdateFilma(id, obj);
        }

        [HttpGet("filter/multiple")]
        public IEnumerable<Model.ViewRequests.FilmoviView> GetByMultipleFilters(int? zanrid, int? glumacid, int? reziserid)
        {
            return _filmovi.GetFilmoviByMultipleFilters(zanrid, glumacid, reziserid);
        }

        [HttpGet("preporuka")]
        public IEnumerable<Model.ViewRequests.FilmoviView> GetPreporuka(int korisnikid)
        {
            return _filmovi.GetPreprukuByKorisnikID(korisnikid);
        }


        [HttpDelete("{id}")]
        public bool Delete(int id)
        {
            return _filmovi.DeleteById(id);
        }

    }
}