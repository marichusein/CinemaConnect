using eCinemaConnect.Model;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
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
    public class GlumciController : ControllerBase
    {
        private readonly IGlumci _glumci;

        public GlumciController(IGlumci glumci)
        {
           _glumci= glumci;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.GlumciView> Get()
        {
           return _glumci.GetAll();
        }
        [HttpGet("{id}")]
        public Model.ViewRequests.GlumciView GetById(int id)
        {
            return _glumci.GetObj(id);
        }

        [HttpGet("filmovibyglumacid/{Glumacid}")]
        public IEnumerable<FilmoviView> GetByGlumacId(int Glumacid)
        {
            return _glumci.VratiFilmoveZaGlumca(Glumacid);
        }
        [HttpPost()]
        public Model.ViewRequests.GlumciView AddGlumca(GlumciInsert obj)
        {
            return _glumci.AddObj(obj);
        }

        [HttpPut("{id}")]
        public Model.ViewRequests.GlumciView UpdateGlumca(int id, GlumciUpdate obj)
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