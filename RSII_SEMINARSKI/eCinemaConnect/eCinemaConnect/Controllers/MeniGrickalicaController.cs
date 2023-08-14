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
    public class MeniGrickalicaController : ControllerBase
    {
        private readonly IMeniGrickalica _meni;

        public MeniGrickalicaController(IMeniGrickalica meni)
        {
           _meni= meni;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.MeniGrickalicaView> Get()
        {
           return _meni.GetAll();
        }
        [HttpGet("{id}")]
        public Model.ViewRequests.MeniGrickalicaView GetById(int id)
        {
            return _meni.GetById(id);
        }

        [HttpPost()]
        public Model.ViewRequests.MeniGrickalicaView AddMenu(MeniGrickalicaInsert obj)
        {
            return _meni.AddMeni(obj);
        }

        [HttpPut("{id}")]
        public Model.ViewRequests.MeniGrickalicaView UpdateMenu(int id, MeniGrickalicaUpdate obj)
        {
            return _meni.UpdateMeni(id, obj);
        }

        [HttpDelete("{id}")]
        public bool Delete(int id)
        {
            return _meni.DeleteById(id);
        }

    }
}