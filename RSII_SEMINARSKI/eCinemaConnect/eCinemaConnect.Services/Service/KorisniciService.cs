using AutoMapper;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using eCinemaConnect.Services.RabbitMQ;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Service
{
    public class KorisniciService : BaseService<KorisniciView, KorisniciInsert, KorisniciUpdate, Korisnici, Korisnici>, IKorisnici
    {
        CinemaContext _context;
        public IMapper _mapper { get; set; }
        public ITipGledatelja _tipGledatelja { get; set; }
        private readonly IRabbitMQProducer _rabbitMQProducer;
        public KorisniciService(CinemaContext context, IMapper mapper, ITipGledatelja tipGledatelja, IRabbitMQProducer rabbitMQProducer) : base(context, mapper)
        {
            _context = context;
            _mapper = mapper;
            _tipGledatelja = tipGledatelja;
            _rabbitMQProducer= rabbitMQProducer;
        }

        public KorisniciView Login(KorisniciLogin login)
        {
            // Pretražite korisnike u bazi podataka na osnovu korisničkog imena (ili email-a)
            var user = _context.Korisnicis.SingleOrDefault(u => u.KorisnickoIme == login.KorisnickoIme);

            if (user != null)
            {
                // Proverite da li je unesena lozinka ispravna
                if (VerifyPassword(login.Lozinka, user.Lozinka, user.Salt))
                {
                    // Lozinka je ispravna, korisnik se može prijaviti

                    // Ovde možete vratiti KorisniciView sa podacima o prijavljenom korisniku
                    var korisnikView = _mapper.Map<KorisniciView>(user);
                    return korisnikView;
                }
            }

            // Lozinka nije ispravna ili korisnik ne postoji
            // Ovde možete vratiti odgovarajuću poruku o grešci ili null ako želite
            return null;
        }


        private byte[] GenerateSalt()
        {
            byte[] salt = new byte[16]; // 16 bajtova soli
            using (RNGCryptoServiceProvider rngCsp = new RNGCryptoServiceProvider())
            {
                rngCsp.GetBytes(salt);
            }
            return salt;
        }

        private byte[] HashPassword(string password, byte[] salt)
        {
            using (Rfc2898DeriveBytes pbkdf2 = new Rfc2898DeriveBytes(password, salt, 10000))
            {
                return pbkdf2.GetBytes(32);
            }
        }

        private bool VerifyPassword(string enteredPassword, string storedPasswordHash, byte[] storedSalt)
        {
            // Hashirajte unesenu lozinku koristeći isti salt iz baze podataka
            byte[] enteredPasswordHash = HashPassword(enteredPassword, storedSalt);

            // Pretvorite hashiranu lozinku u string za upoređivanje sa vrednošću u bazi podataka
            string enteredPasswordHashString = BitConverter.ToString(enteredPasswordHash).Replace("-", "").ToLower();

            // Uporedite unesenu lozinku sa vrednošću u bazi podataka
            return enteredPasswordHashString == storedPasswordHash;
        }

        public class SiginUpResult
        {
            public bool Success { get; set; }
            public string ErrorMessage { get; set; }
            public KorisniciView RegisteredKorisnik { get; set; }
        }

        public SiginUpResult SiginUp(KorisniciRegistration registration)
        {
            // Generišite sol (salt) za novog korisnika
            byte[] salt = GenerateSalt();

            // Hashirajte lozinku koju je korisnik uneo prilikom registracije
            byte[] hashedPassword = HashPassword(registration.Lozinka, salt);

            // Pretvorite hashiranu lozinku u string
            string hashedPasswordString = BitConverter.ToString(hashedPassword).Replace("-", "").ToLower();

            // Provera da li već postoji korisnik sa istim emailom ili korisničkim imenom
            var existingKorisnik = _context.Korisnicis.FirstOrDefault(k => k.KorisnickoIme == registration.KorisnickoIme || k.Email == registration.Email);

            if (existingKorisnik != null)
            {
                return new SiginUpResult
                {
                    Success = false,
                    ErrorMessage = "Korisničko ime ili email već postoje.",
                    RegisteredKorisnik = null
                };
            }

            // Kreirajte novog korisnika sa hash-iranom lozinkom i solju
            var newKorisnik = _mapper.Map<Korisnici>(registration);
            newKorisnik.Salt = salt;
            newKorisnik.Lozinka = hashedPasswordString;

            // Dodajte novog korisnika u bazu podataka
            _context.Korisnicis.Add(newKorisnik);
            _context.SaveChanges();

            // Vratite KorisniciView sa podacima o registrovanom korisniku
            var korisnikView = _mapper.Map<KorisniciView>(newKorisnik);

            return new SiginUpResult
            {
                Success = true,
                ErrorMessage = null,
                RegisteredKorisnik = korisnikView
            };
        }

        public KorisniciView UpdateProfiil(int id, KorisniciUpdate obj)
        {
            // Pronađite korisnika u bazi podataka na osnovu ID-ja
            var korisnik = _context.Korisnicis.SingleOrDefault(k => k.Idkorisnika == id);

            if (korisnik == null)
            {
                // Ako korisnik nije pronađen, možete vratiti odgovarajuću poruku o grešci ili null
                return null;
            }

            // Ažurirajte ime, prezime i/ili lozinku korisnika prema objektu KorisniciUpdate
            if (!string.IsNullOrEmpty(obj.Ime))
            {
                korisnik.Ime = obj.Ime;
            }

            if (!string.IsNullOrEmpty(obj.Prezime))
            {
                korisnik.Prezime = obj.Prezime;
            }

            if (!string.IsNullOrEmpty(obj.Lozinka))
            {
                // Generišite novu sol za korisnika
                byte[] newSalt = GenerateSalt();

                // Hashirajte novu lozinku
                byte[] newHashedPassword = HashPassword(obj.Lozinka, newSalt);
                string newHashedPasswordString = BitConverter.ToString(newHashedPassword).Replace("-", "").ToLower();

                // Ažurirajte lozinku i sol korisnika
                korisnik.Lozinka = newHashedPasswordString;
                korisnik.Salt = newSalt;
            }

            // Sačuvajte promene u bazi podataka
            _context.SaveChanges();

            // Vratite ažurirani KorisniciView sa novim podacima
            var updatedKorisnikView = _mapper.Map<KorisniciView>(korisnik);
            return updatedKorisnikView;
        }

        public void SendMail(int korisnikID)
        {

            var objektMail = new EmailModel();
            objektMail.Recipient = _context.Korisnicis.Where(x => x.Idkorisnika == korisnikID).FirstOrDefault().Email??"husein.maric@edu.fit.ba";
            objektMail.Subject = "SENDING";
            objektMail.Content="SUPER";
            try
            {
                _rabbitMQProducer.SendMessage(objektMail);
                Thread.Sleep(TimeSpan.FromSeconds(15));
                
            }
            catch (Exception ex)
            {
                
            }

        }

    }

   
}