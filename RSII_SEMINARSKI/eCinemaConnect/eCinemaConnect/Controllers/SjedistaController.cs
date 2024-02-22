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

    public class SjedistaController : ControllerBase
    {
        private readonly ISjediste _basic;

        public SjedistaController(ISjediste basic)
        {
           _basic= basic;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.SjedistaView> Get()
        {
           return _basic.GetAllWithPovezanoSvojstvo();
        }
        [HttpGet("{id}")]
        public Model.ViewRequests.SjedistaView GetById(int id)
        {
            return _basic.GetById(id);
        }

        [HttpGet("sala/{id}")]
        public IEnumerable<Model.ViewRequests.SjedistaView> GetBySAla(int id)
        {
            return _basic.GetAllBySala(id);
        }

        [HttpPost()]
        public Model.ViewRequests.SjedistaView AddMenu(SjedistaInsert obj)
        {
            return _basic.AddSpecial(obj);
        }

        [HttpPut("{id}")]
        public Model.ViewRequests.SjedistaView UpdateMenu(int id, SjedistaUpdate obj)
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