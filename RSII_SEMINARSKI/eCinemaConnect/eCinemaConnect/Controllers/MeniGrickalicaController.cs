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
    public class MeniGrickalicaController : ControllerBase
    {
        private readonly IMeniGrickalica _meni;

        public MeniGrickalicaController(IMeniGrickalica meni)
        {
            _meni = meni;
        }

        [HttpGet]
        public async Task<IEnumerable<Model.ViewRequests.MeniGrickalicaView>> Get()
        {
            return await _meni.GetAllAsync();
        }

        [HttpGet("{id}")]
        public async Task<Model.ViewRequests.MeniGrickalicaView> GetById(int id)
        {
            return await _meni.GetObjAsync(id);
        }

        [HttpPost]
        public async Task<Model.ViewRequests.MeniGrickalicaView> AddMenu(MeniGrickalicaInsert obj)
        {
            return await _meni.AddObjAsync(obj);
        }

        [HttpPut("{id}")]
        public async Task<Model.ViewRequests.MeniGrickalicaView> UpdateMenu(int id, MeniGrickalicaUpdate obj)
        {
            return await _meni.UpdateObjAsync(id, obj);
        }

        [HttpDelete("{id}")]
        public async Task<bool> Delete(int id)
        {
            return await _meni.DeleteByIdAsync(id);
        }
    }
}
