using eCinemaConnect.Model;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Services;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using Microsoft.AspNetCore.Authorization;
//using eCinemaConnect.Services.Database;
using Microsoft.AspNetCore.Mvc;

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
           _glumci= glumci;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.RezervacijaView> Get()
        {
           return _glumci.GetAll();
        }

        [HttpGet("brojkarata")]
        public IActionResult GetBrojKarata(DateTime? od = null, DateTime? doo = null)
        {
            try
            {
                var rezultat = _glumci.BrojKupljenihKarataPoFilmu(od, doo);
                return Ok(rezultat);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Došlo je do greške prilikom dobavljanja broja karata: " + ex.Message);
            }
        }

        [HttpGet("zardaFilma")]
        public IActionResult GetZaradu(DateTime? od = null, DateTime? doo = null)
        {
            try
            {
                var rezultat = _glumci.ZaradaOdFilmova(od, doo);
                return Ok(rezultat);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Došlo je do greške prilikom dobavljanja broja karata: " + ex.Message);
            }
        }

        [HttpGet("kartePoZanru")]
        public IActionResult GetKartePoZanru()
        {
            try
            {
                var rezultat = _glumci.BrojProdatihKarataPoZanru();
                return Ok(rezultat);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Došlo je do greške prilikom dobavljanja broja karata: " + ex.Message);
            }
        }

        [HttpGet("{id}")]
        public Model.ViewRequests.RezervacijaView GetById(int id)
        {
            return _glumci.GetObj(id);
        }

        [HttpPost()]
        public Model.ViewRequests.RezervacijaView AddGlumca(RezervacijaInsert obj)
        {
            return _glumci.KreirajRezervaciju(obj);
        }

        [HttpPut("{id}")]
        public Model.ViewRequests.RezervacijaView UpdateGlumca(int id, RezervacijaUpdate obj)
        {
            return _glumci.UpdateObj(id, obj);
        }

        [HttpPost("PotvrdiUlazakRezervaciju={id}")]
        public IActionResult PotvrdiUlazakRezervaciju(int id)
        {
            try
            {
                _glumci.OznaciRezervacijuKaoUsla(id);
                return Ok($"Ulazak za rezervaciju s ID-om {id} je potvrdjen.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Došlo je do greske prilikom potvrde ulaska rezervacije: " + ex.Message);
            }
        }

        [HttpDelete("{id}")]
        public bool Delete(int id)
        {
            return _glumci.DeleteById(id);
        }

    }
}