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
    [Authorize]

    public class OcijeniFilmController : ControllerBase
    {
        private readonly IOcijeni _ocijeni;

        public OcijeniFilmController(IOcijeni ocjeni)
        {
           _ocijeni= ocjeni;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.OcijeniFilmView> Get()
        {
           return _ocijeni.GetAll();
        }
        [HttpGet("{id}")]
        public Model.ViewRequests.OcijeniFilmView GetById(int id)
        {
            return _ocijeni.GetObj(id);
        }
        [HttpGet("film/{id}")]
        public List<Model.ViewRequests.OcijeniFilmView> GetByIdFilm(int id)
        {
            return _ocijeni.GetKomentareZaFilm(id);
        }

        [HttpPost()]
        public Model.ViewRequests.OcijeniFilmView AddGlumca(OcijeniFilmInsert obj)
        {
            return _ocijeni.AddObj(obj);
        }

        [HttpPut("{id}")]
        public Model.ViewRequests.OcijeniFilmView UpdateGlumca(int id, OcijeniFilmUpdate obj)
        {
            return _ocijeni.UpdateObj(id, obj);
        }

        [HttpDelete("{id}")]
        public bool Delete(int id)
        {
            return _ocijeni.DeleteById(id);
        }

        [HttpGet("/film")]
        public double GetOcjenu(int id)
        {
            return _ocijeni.getProsjekZaFilm(id);
        }

    }
}