using eCinemaConnect.Model;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Services.Interface;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinemaConnect.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class ObavijestiController : ControllerBase
    {
        private readonly IObavijesti _obavijest;

        public ObavijestiController(IObavijesti obavijesti)
        {
            _obavijest = obavijesti;
        }

        [HttpGet]
        public async Task<IEnumerable<Model.ViewRequests.ObavijestiView>> Get()
        {
            return await _obavijest.GetAllAsync();
        }

        [HttpGet("{id}")]
        public async Task<Model.ViewRequests.ObavijestiView> GetById(int id)
        {
            return await _obavijest.GetObjAsync(id);
        }

        [HttpPost]
        public async Task<Model.ViewRequests.ObavijestiView> AddFilmovi(ObavijestiInsert obj)
        {
            return await _obavijest.AddObjAsync(obj);
        }

        [HttpPut("{id}")]
        public async Task<Model.ViewRequests.ObavijestiView> UpdateFilma(int id, ObavijestiUpdate obj)
        {
            return await _obavijest.UpdateObjAsync(id, obj);
        }

        [HttpDelete("{id}")]
        public async Task<bool> Delete(int id)
        {
            return await _obavijest.DeleteByIdAsync(id);
        }
    }
}
