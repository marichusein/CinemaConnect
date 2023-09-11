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
    public class RezervacijeController : ControllerBase
    {
        private readonly IRezervacije _glumci;

        public RezervacijeController(IRezervacije glumci)
        {
           _glumci= glumci;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.RezervacijaView> Get()
        {
           return _glumci.GetAll();
        }
        [HttpGet("{id}")]
        public Model.ViewRequests.RezervacijaView GetById(int id)
        {
            return _glumci.GetObj(id);
        }

        [HttpPost()]
        public Model.ViewRequests.RezervacijaView AddGlumca(RezervacijaInsert obj)
        {
            return _glumci.KreirajRezervaciju(obj);
        }

        [HttpPut("{id}")]
        public Model.ViewRequests.RezervacijaView UpdateGlumca(int id, RezervacijaUpdate obj)
        {
            return _glumci.UpdateObj(id, obj);
        }

        [HttpDelete("{id}")]
        public bool Delete(int id)
        {
            return _glumci.DeleteById(id);
        }

    }
}