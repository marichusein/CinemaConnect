using eCinemaConnect.Model;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Services;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
//using eCinemaConnect.Services.Database;
using Microsoft.AspNetCore.Mvc;

namespace eCinemaConnect.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProjekcijeController : ControllerBase
    {
        private readonly IProjekcije _projekcije;

        public ProjekcijeController(IProjekcije projekcije)
        {
           _projekcije= projekcije;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.ProjekcijeView> Get()
        {
           return _projekcije.GetAll();
        }
        [HttpGet("film/{filmId}")]
        public IEnumerable<Model.ViewRequests.ProjekcijeView> GetByFilm(int filmId)
        {
            return _projekcije.GetByFilm(filmId);
        }
        [HttpGet("{id}")]
        public Model.ViewRequests.ProjekcijeView GetById(int id)
        {
            return _projekcije.GetById(id);
        }

        [HttpGet("sjedista/{projekcijaID}")]
        public List<Model.ViewRequests.SjedistaViewProjekcija> GetByIdP(int projekcijaID)
        {
            return _projekcije.GetSjedistaByProjekcija(projekcijaID);
        }

        [HttpPost()]
        public Model.ViewRequests.ProjekcijeView AddProjekciju(ProjekcijeInsert obj)
        {
            return _projekcije.AddProjekciju(obj);
        }

        [HttpPut("{id}")]
        public Model.ViewRequests.ProjekcijeView UpdateProjekciju(int id, ProjekcijeUpdate obj)
        {
            return _projekcije.UpdateProjekciju(id, obj);
        }

        [HttpDelete("{id}")]
        public bool Delete(int id)
        {
            return _projekcije.DeleteById(id);
        }

    }
}