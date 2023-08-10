using eCinemaConnect.Model;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Services;
//using eCinemaConnect.Services.Database;
using Microsoft.AspNetCore.Mvc;

namespace eCinemaConnect.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TipGledateljaController : ControllerBase
    {
        private readonly ITipGledatelja _tipGledateljaService;

        public TipGledateljaController(ITipGledatelja tip)
        {
            _tipGledateljaService = tip;
        }

        [HttpGet()]
        public IEnumerable<TipGledatelja> Get()
        {
           return _tipGledateljaService.GetAll();
        }

        [HttpPost()]
        public Model.TipGledatelja AddTipGledatelja(TipGledateljaInsert obj)
        {
            return _tipGledateljaService.AddTipGledatelja(obj);
        }

        [HttpPut("{id}")]
        public Model.TipGledatelja UpdateTipGledatelja(int id, TipGledateljaUpdate obj)
        {
            return _tipGledateljaService.UpdateTipGledatelja(id,obj);
        }

        [HttpDelete("{id}")]
        public bool DeleteTipGledatelja(int id)
        {
            return _tipGledateljaService.DeleteById(id);
        }

    }
}