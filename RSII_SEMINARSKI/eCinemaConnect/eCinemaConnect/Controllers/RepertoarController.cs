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

    public class RepertoarController : ControllerBase
    {
        private readonly IRepertoar _basic;

        public RepertoarController(IRepertoar basic)
        {
           _basic= basic;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.RepertoarView> Get()
        {
           return _basic.GetAll();
        }
        [HttpGet("{id}")]
        public Model.ViewRequests.RepertoarView GetById(int id)
        {
            return _basic.GetObj(id);
        }

        [HttpPost()]
        public Model.ViewRequests.RepertoarView AddMenu(RepertoarInsert obj)
        {
            return _basic.AddObj(obj);
        }

        [HttpPut("{id}")]
        public Model.ViewRequests.RepertoarView UpdateMenu(int id, RepertoarUpdate obj)
        {
            return _basic.UpdateObj(id, obj);
        }

        [HttpDelete("{id}")]
        public bool Delete(int id)
        {
            return _basic.DeleteById(id);
        }

    }
}