using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using eCinemaConnect.Services.Interface;
using Microsoft.AspNetCore.Authorization;

namespace eCinemaConnect.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class RezervacijeController : ControllerBase
    {
        private readonly IRezervacije _glumci;

        public RezervacijeController(IRezervacije glumci)
        {
            _glumci = glumci;
        }

        [HttpGet]
        public async Task<IEnumerable<Model.ViewRequests.RezervacijaView>> Get()
        {
            return await _glumci.GetAllAsync();
        }

        [HttpGet("/aktivnebykorisnik/{id}")]
        public async Task<IEnumerable<Model.ViewRequests.RezervacijaView>> GetAktivne(int id)
        {
            return await _glumci.AktivneRezervacijeByKorisnikAsync(id);
        }

        [HttpGet("/neaktivnebykorisnik/{id}")]
        public async Task<IEnumerable<Model.ViewRequests.RezervacijaView>> GetNeaktivne(int id)
        {
            return await _glumci.NeaktivneRezervacijeByKorisnikAsync(id);
        }

        [HttpGet("brojkarata")]
        public async Task<IActionResult> GetBrojKarata(DateTime? od = null, DateTime? doo = null)
        {
            try
            {
                var rezultat = await _glumci.BrojKupljenihKarataPoFilmuAsync(od, doo);
                return Ok(rezultat);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Došlo je do greške prilikom dobavljanja broja karata: " + ex.Message);
            }
        }

        [HttpGet("zardaFilma")]
        public async Task<IActionResult> GetZaradu(DateTime? od = null, DateTime? doo = null)
        {
            try
            {
                var rezultat = await _glumci.ZaradaOdFilmovaAsync(od, doo);
                return Ok(rezultat);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Došlo je do greške prilikom dobavljanja broja karata: " + ex.Message);
            }
        }

        [HttpGet("kartePoZanru")]
        public async Task<IActionResult> GetKartePoZanru()
        {
            try
            {
                var rezultat = await _glumci.BrojProdatihKarataPoZanruAsync();
                return Ok(rezultat);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Došlo je do greške prilikom dobavljanja broja karata: " + ex.Message);
            }
        }

        [HttpGet("{id}")]
        public async Task<Model.ViewRequests.RezervacijaView> GetById(int id)
        {
            return await _glumci.GetObjAsync(id);
        }

        [HttpPost()]
        public async Task<Model.ViewRequests.RezervacijaView> AddGlumca(RezervacijaInsert obj)
        {
            return await _glumci.KreirajRezervacijuAsync(obj);
        }

        [HttpPut("{id}")]
        public async Task<Model.ViewRequests.RezervacijaView> UpdateGlumca(int id, RezervacijaUpdate obj)
        {
            return await _glumci.UpdateObjAsync(id, obj);
        }

        [HttpPost("PotvrdiUlazakRezervaciju={id}")]
        public async Task<IActionResult> PotvrdiUlazakRezervaciju(int id)
        {
            try
            {
                await _glumci.OznaciRezervacijuKaoUslaAsync(id);
                return Ok($"Ulazak za rezervaciju s ID-om {id} je potvrdjen.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Došlo je do greske prilikom potvrde ulaska rezervacije: " + ex.Message);
            }
        }

        [HttpDelete("{id}")]
        public async Task<bool> Delete(int id)
        {
            return await _glumci.DeleteByIdAsync(id);
        }
    }
}
