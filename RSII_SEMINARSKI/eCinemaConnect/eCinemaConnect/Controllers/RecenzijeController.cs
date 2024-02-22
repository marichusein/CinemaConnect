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

    public class RecenzijeController : ControllerBase
    {
        private readonly IRecenzije _basic;

        public RecenzijeController(IRecenzije basic)
        {
           _basic= basic;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.RecenzijeView> Get()
        {
           return _basic.GetAllWithPovezanoSvojstvo();
        }
        [HttpGet("{id}")]
        public Model.ViewRequests.RecenzijeView GetById(int id)
        {
            return _basic.GetById(id);
        }

        [HttpPost()]
        public Model.ViewRequests.RecenzijeView AddMenu(RecenzijeInsert obj)
        {
            return _basic.AddRecenziju(obj);
        }

        [HttpPut("{id}")]
        public Model.ViewRequests.RecenzijeView UpdateMenu(int id, RecenzijeUpdate obj)
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