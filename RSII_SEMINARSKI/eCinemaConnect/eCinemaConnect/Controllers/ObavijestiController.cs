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

    public class ObavijestiController : ControllerBase
    {
        private readonly IObavijesti _obavijest;

        public ObavijestiController(IObavijesti obavijesti)
        {
           _obavijest= obavijesti;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.ObavijestiView> Get()
        {
           return _obavijest.GetAll();
        }

        [HttpGet("{id}")]
        public Model.ViewRequests.ObavijestiView GetById(int id)
        {
            return _obavijest.GetObj(id);
        }

        [HttpPost()]
        public Model.ViewRequests.ObavijestiView AddFilmovi(ObavijestiInsert obj)
        {
            return _obavijest.AddObj(obj);
        }

        [HttpPut("{id}")]
        public Model.ViewRequests.ObavijestiView UpdateFilma(int id, ObavijestiUpdate obj)
        {
            return _obavijest.UpdateObj(id, obj);
        }

       


        [HttpDelete("{id}")]
        public bool Delete(int id)
        {
            return _obavijest.DeleteById(id);
        }

    }
}