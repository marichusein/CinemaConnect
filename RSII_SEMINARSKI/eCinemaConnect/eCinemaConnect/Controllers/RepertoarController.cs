using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
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

    public class RepertoarController : ControllerBase
    {
        private readonly IRepertoar _basic;

        public RepertoarController(IRepertoar basic)
        {
            _basic = basic;
        }

        [HttpGet]
        public async Task<IEnumerable<RepertoarView>> GetAsync()
        {
            return await _basic.GetAllAsync();
        }

        [HttpGet("{id}")]
        public async Task<RepertoarView> GetByIdAsync(int id)
        {
            return await _basic.GetObjAsync(id);
        }

        [HttpPost]
        public async Task<RepertoarView> AddMenuAsync(RepertoarInsert obj)
        {
            return await _basic.AddObjAsync(obj);
        }

        [HttpPut("{id}")]
        public async Task<RepertoarView> UpdateMenuAsync(int id, RepertoarUpdate obj)
        {
            return await _basic.UpdateObjAsync(id, obj);
        }

        [HttpDelete("{id}")]
        public async Task<bool> DeleteAsync(int id)
        {
            return await _basic.DeleteByIdAsync(id);
        }

    }
}
