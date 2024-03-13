using eCinemaConnect.Model;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using eCinemaConnect.Services.Interface;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinemaConnect.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisniciController : ControllerBase
    {
        private readonly IKorisnici _korisnici;

        public KorisniciController(IKorisnici korisnici)
        {
            _korisnici = korisnici;
        }

        [HttpGet()]
        public async Task<IEnumerable<KorisniciView>> Get()
        {
            return await _korisnici.GetAllAsync();
        }

        [HttpGet("{id}")]
        public async Task<KorisniciView> GetById(int id)
        {
            return await _korisnici.GetObjAsync(id);
        }

        [HttpPost()]
        public async Task<KorisniciView> AddGlumca(KorisniciInsert obj)
        {
            return await _korisnici.AddObjAsync(obj);
        }

        [HttpPost("login")]
        public async Task<KorisniciView> LoginAsync(KorisniciLogin obj)
        {
            return await _korisnici.LoginAsync(obj);
        }

        [HttpPost("loginAdmin")]
        public async Task<KorisniciView> LoginAdminAsync(KorisniciLogin obj)
        {
            return await _korisnici.LoginAdminAsync(obj);
        }

        [HttpPost("siginup")]
        public async Task<IActionResult> SiginUp(KorisniciRegistration obj)
        {
            var result = await _korisnici.SiginUpAsync(obj);

            if (result.Success)
            {
                return Ok(result.RegisteredKorisnik);
            }
            else
            {
                return BadRequest(result.ErrorMessage);
            }
        }

        [HttpPut("{id}")]
        public async Task<KorisniciView> UpdateGlumca(int id, KorisniciUpdate obj)
        {
            return await _korisnici.UpdateProfiilAsync(id, obj);
        }

        [HttpDelete("{id}")]
        public async Task<bool> Delete(int id)
        {
            return await _korisnici.DeleteByIdAsync(id);
        }

        [HttpPost("sendMail")]
        public async Task SendMail(int korisnikID)
        {
            await _korisnici.SendMailAsync(korisnikID);
        }

        [HttpPost("sendMailKupovina")]
        public async Task SendMailKupovina(int korisnikID, string NazivFilma, DateTime Datum, string sala, int brojkarata, decimal cijena)
        {
            await _korisnici.SendPurchaseConfirmationEmailAsync(korisnikID, NazivFilma, Datum, sala, brojkarata, cijena);
        }
    }
}
