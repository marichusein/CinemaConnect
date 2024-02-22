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

    public class ReziseriController : ControllerBase
    {
        private readonly IReziser _reziser;

        public ReziseriController(IReziser reziser)
        {
           _reziser= reziser;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.ReziseriView> Get()
        {
           return _reziser.GetAll();
        }
        [HttpGet("{id}")]
        public Model.ViewRequests.ReziseriView Get(int id)
        {
            return _reziser.GetObj(id);
        }

        [HttpPost()]
        public Model.ViewRequests.ReziseriView AddRezisera(ReziserInsert obj)
        {
            return _reziser.AddObj(obj);
        }


        [HttpPut("{id}")]
        public Model.ViewRequests.ReziseriView UpdateRezisera(int id, ReziserUpdate obj)
        {
            return _reziser.UpdateObj(id, obj);
        }

        [HttpDelete("{id}")]
        public bool Delete(int id)
        {
            return _reziser.DeleteById(id);
        }

    }
}