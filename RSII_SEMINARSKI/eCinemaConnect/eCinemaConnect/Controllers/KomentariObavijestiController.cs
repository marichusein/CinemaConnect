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
    public class KomentariObavijestiController : ControllerBase
    {
        private readonly IKomentariObavijesti _glumci;

        public KomentariObavijestiController(IKomentariObavijesti glumci)
        {
            _glumci = glumci;
        }

        [HttpGet]
        public async Task<IEnumerable<Model.ViewRequests.KomentariObavijestiView>> Get()
        {
            return await _glumci.GetAllAsync();
        }

        [HttpGet("{id}")]
        public async Task<Model.ViewRequests.KomentariObavijestiView> GetById(int id)
        {
            return await _glumci.GetObjAsync(id);
        }

        [HttpPost]
        public async Task<Model.ViewRequests.KomentariObavijestiView> AddGlumca(KomentariObavijestiInsert obj)
        {
            return await _glumci.AddObjAsync(obj);
        }

        [HttpPut("{id}")]
        public async Task<Model.ViewRequests.KomentariObavijestiView> UpdateGlumca(int id, KomentariObavijestiUpdate obj)
        {
            return await _glumci.UpdateObjAsync(id, obj);
        }

        [HttpDelete("{id}")]
        public async Task<bool> Delete(int id)
        {
            return await _glumci.DeleteByIdAsync(id);
        }

        [HttpGet("obavijesti/{id}")]
        public async Task<List<Model.ViewRequests.KomentariObavijestiView>> GetByIdO(int id)
        {
            return await _glumci.getByObavijestAsync(id);
        }
    }
}
