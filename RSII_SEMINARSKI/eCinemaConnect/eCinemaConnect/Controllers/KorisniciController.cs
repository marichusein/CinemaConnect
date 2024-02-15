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
    public class KorisniciController : ControllerBase
    {
        private readonly IKorisnici _korisnici;

        public KorisniciController(IKorisnici korisnici)
        {
           _korisnici= korisnici;
        }

        [HttpGet()]
        public IEnumerable<Model.ViewRequests.KorisniciView> Get()
        {
           return _korisnici.GetAll();
        }
        [HttpGet("{id}")]
        public Model.ViewRequests.KorisniciView GetById(int id)
        {
            return _korisnici.GetObj(id);
        }

        [HttpPost()]
        public Model.ViewRequests.KorisniciView AddGlumca(KorisniciInsert obj)
        {
            return _korisnici.AddObj(obj);
        }

        [HttpPost("login")]
        public Model.ViewRequests.KorisniciView Login(KorisniciLogin obj)
        {
            return _korisnici.Login(obj);
        }
        [HttpPost("siginup")]
        public IActionResult SiginUp(KorisniciRegistration obj)
        {
            var result = _korisnici.SiginUp(obj);

            if (result.Success)
            {
                // Registracija uspesna, vratite KorisniciView
                return Ok(result.RegisteredKorisnik);
            }
            else
            {
                // Registracija nije uspela, vratite odgovarajuću poruku o gresci
                return BadRequest(result.ErrorMessage);
            }
        }


        [HttpPut("{id}")]
        public Model.ViewRequests.KorisniciView UpdateGlumca(int id, KorisniciUpdate obj)
        {
            return _korisnici.UpdateProfiil(id, obj);
        }

        [HttpDelete("{id}")]
        public bool Delete(int id)
        {
            return _korisnici.DeleteById(id);
        }

        [HttpPost("sendMail")]
        public void SendMail(int korisnikID)
        {
             _korisnici.SendMail(korisnikID);

           
        }

    }
}