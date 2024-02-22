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
    public class KomentariObavijestiController : ControllerBase
    {
        private readonly IKomentariObavijesti _glumci;

        public KomentariObavijestiController(IKomentariObavijesti glumci)
        {
           _glumci= glumci;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.KomentariObavijestiView> Get()
        {
           return _glumci.GetAll();
        }
        [HttpGet("{id}")]
        public Model.ViewRequests.KomentariObavijestiView GetById(int id)
        {
            return _glumci.GetObj(id);
        }

        [HttpPost()]
        public Model.ViewRequests.KomentariObavijestiView AddGlumca(KomentariObavijestiInsert obj)
        {
            return _glumci.AddObj(obj);
        }

        [HttpPut("{id}")]
        public Model.ViewRequests.KomentariObavijestiView UpdateGlumca(int id, KomentariObavijestiUpdate obj)
        {
            return _glumci.UpdateObj(id, obj);
        }

        [HttpDelete("{id}")]
        public bool Delete(int id)
        {
            return _glumci.DeleteById(id);
        }

        [HttpGet("obavijesti/{id}")]
        public List<Model.ViewRequests.KomentariObavijestiView> GetByIdO(int id)
        {
            return _glumci.getByObavijest(id);
        }
    }
}