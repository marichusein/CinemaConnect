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

        [HttpPost()]
        public Model.ViewRequests.GlumciView AddGlumca(GlumciInsert obj)
        {
            return _glumci.AddGlumca(obj);
        }

        [HttpPut("{id}")]
        public Model.ViewRequests.GlumciView UpdateGlumca(int id, GlumciUpdate obj)
        {
            return _glumci.UpdateGlumca(id, obj);
        }

        [HttpDelete("{id}")]
        public bool DeleteTipGledatelja(int id)
        {
            return _glumci.DeleteById(id);
        }

    }
}