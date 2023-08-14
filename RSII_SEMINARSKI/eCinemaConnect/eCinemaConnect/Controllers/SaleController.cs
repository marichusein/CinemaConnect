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
    public class SaleController : ControllerBase
    {
        private readonly ISale _sale;

        public SaleController(ISale sale)
        {
           _sale= sale;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.SalaView> Get()
        {
           return _sale.GetAll();
        }
        [HttpGet("{id}")]
        public Model.ViewRequests.SalaView GetById(int id)
        {
            return _sale.GetById(id);
        }

        [HttpPost()]
        public Model.ViewRequests.SalaView AddZanr(SaleInsert obj)
        {
            return _sale.AddSalu(obj);
        }

        [HttpPut("{id}")]
        public Model.ViewRequests.SalaView UpdateSalu(int id, SalaUpdate obj)
        {
            return _sale.UpdateSalu(id, obj);
        }

        [HttpDelete("{id}")]
        public bool Delete(int id)
        {
            return _sale.DeleteById(id);
        }

    }
}