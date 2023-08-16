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
    public class ZanroviController : ControllerBase
    {
        private readonly IZanrovi _zanrovi;

        public ZanroviController(IZanrovi zanrovi)
        {
           _zanrovi= zanrovi;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.ZanroviView> Get()
        {
           return _zanrovi.GetAll();
        }
        [HttpGet("{id}")]
        public Model.ViewRequests.ZanroviView GetById(int id)
        {
            return _zanrovi.GetObj(id);
        }

        [HttpPost()]
        public Model.ViewRequests.ZanroviView AddZanr(ZanroviInsert obj)
        {
            return _zanrovi.AddObj(obj);
        }

        [HttpPut("{id}")]
        public Model.ViewRequests.ZanroviView UpdateZanr(int id, ZanroviUpdate obj)
        {
            return _zanrovi.UpdateObj(id, obj);
        }

        [HttpDelete("{id}")]
        public bool Delete(int id)
        {
            return _zanrovi.DeleteById(id);
        }

    }
}