using AutoMapper;
using eCinemaConnect.Model;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using eCinemaConnect.Services.RabbitMQ;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
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
            _rabbitMQProducer = rabbitMQProducer;
        }

        public async Task<KorisniciView> LoginAsync(KorisniciLogin login)
        {
            var user = await _context.Korisnicis
                .Where(x => x.KorisnickoIme == login.KorisnickoIme)
                .Include(t => t.TipGledatelja)
                .FirstOrDefaultAsync();

            if (user != null && VerifyPassword(login.Lozinka, user.Lozinka, user.Salt))
            {
                var korisnikView = _mapper.Map<KorisniciView>(user);
                korisnikView.Tip = _mapper.Map<TipGledatelja>(user.TipGledatelja);
                return korisnikView;
            }

            return null;
        }

        private async Task<byte[]> GenerateSaltAsync()
        {
            byte[] salt = new byte[16]; // 16 bajtova soli
            using (RNGCryptoServiceProvider rngCsp = new RNGCryptoServiceProvider())
            {
                await Task.Run(() => rngCsp.GetBytes(salt));
            }
            return salt;
        }

        private async Task<byte[]> HashPasswordAsync(string password, byte[] salt)
        {
            return await Task.Run(() =>
            {
                using (Rfc2898DeriveBytes pbkdf2 = new Rfc2898DeriveBytes(password, salt, 10000))
                {
                    return pbkdf2.GetBytes(32);
                }
            });
        }

        private bool VerifyPassword(string enteredPassword, string storedPasswordHash, byte[] storedSalt)
        {
            byte[] enteredPasswordHash = HashPasswordAsync(enteredPassword, storedSalt).Result;

            string enteredPasswordHashString = BitConverter.ToString(enteredPasswordHash).Replace("-", "").ToLower();

            return enteredPasswordHashString == storedPasswordHash;
        }

        public class SiginUpResult
        {
            public bool Success { get; set; }
            public string ErrorMessage { get; set; }
            public KorisniciView RegisteredKorisnik { get; set; }
        }

        public async Task<SiginUpResult> SiginUpAsync(KorisniciRegistration registration)
        {
            byte[] salt = await GenerateSaltAsync();
            byte[] hashedPassword = await HashPasswordAsync(registration.Lozinka, salt);
            string hashedPasswordString = BitConverter.ToString(hashedPassword).Replace("-", "").ToLower();

            var existingKorisnik = await _context.Korisnicis.FirstOrDefaultAsync(k => k.KorisnickoIme == registration.KorisnickoIme || k.Email == registration.Email);

            if (existingKorisnik != null)
            {
                return new SiginUpResult
                {
                    Success = false,
                    ErrorMessage = "Korisničko ime ili email već postoje.",
                    RegisteredKorisnik = null
                };
            }

            var newKorisnik = _mapper.Map<Korisnici>(registration);
            newKorisnik.Salt = salt;
            newKorisnik.Lozinka = hashedPasswordString;
            newKorisnik.TipGledateljaId = 1;

            _context.Korisnicis.Add(newKorisnik);
            await _context.SaveChangesAsync();

            var korisnikView = _mapper.Map<KorisniciView>(newKorisnik);

            return new SiginUpResult
            {
                Success = true,
                ErrorMessage = null,
                RegisteredKorisnik = korisnikView
            };
        }

        public async Task<KorisniciView> UpdateProfiilAsync(int id, KorisniciUpdate obj)
        {
            var korisnik = await _context.Korisnicis.SingleOrDefaultAsync(k => k.Idkorisnika == id);

            if (korisnik == null)
            {
                return null;
            }

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
                byte[] newSalt = await GenerateSaltAsync();
                byte[] newHashedPassword = await HashPasswordAsync(obj.Lozinka, newSalt);
                string newHashedPasswordString = BitConverter.ToString(newHashedPassword).Replace("-", "").ToLower();

                korisnik.Lozinka = newHashedPasswordString;
                korisnik.Salt = newSalt;
            }

            await _context.SaveChangesAsync();

            var updatedKorisnikView = _mapper.Map<KorisniciView>(korisnik);
            return updatedKorisnikView;
        }

        public async Task SendMailAsync(int korisnikID)
        {
            var objektMail = new EmailModel();
            objektMail.Recipient = _context.Korisnicis.Where(x => x.Idkorisnika == korisnikID).FirstOrDefault().Email ?? "husein.maric@edu.fit.ba";
            objektMail.Subject = "CinemaConnect - Vaš prozor u svijet filma";
            objektMail.Content = $"Poštovani,\n\nPozivamo vas da uđete u svijet filma posjetom vašem korisničkom nalogu na CinemaConnect platformi. Tamo ćete pronaći najnovije filmove, recenzije, preporuke i još mnogo toga.\n\nSrdačan pozdrav,\nVaš CinemaConnect tim";

            try
            {
                _rabbitMQProducer.SendMessage(objektMail);
                Thread.Sleep(TimeSpan.FromSeconds(15));
                
            }
            catch (Exception ex)
            {
                
                // Handle or log the exception
            }
        }

        public async Task SendPurchaseConfirmationEmailAsync(int korisnikID, string filmNaziv, DateTime datumPrikazivanja, string sala, int brojKarata, decimal ukupnaCijena)
        {
            var korisnik = _context.Korisnicis.FirstOrDefault(x => x.Idkorisnika == korisnikID);
            if (korisnik == null)
            {
                return;
            }

            var objektMail = new EmailModel();
            objektMail.Recipient = korisnik.Email;
            objektMail.Subject = "Potvrda o kupovini karata - CinemaConnect";
            objektMail.Content = $"Poštovani {korisnik.Ime},\n\n";
            objektMail.Content += $"Ovo je potvrda da ste uspješno kupili karte za film '{filmNaziv}' za prikazivanje dana {datumPrikazivanja.ToString("dd.MM.yyyy")} u sali {sala}.\n\n";
            objektMail.Content += $"Broj kupljenih karata: {brojKarata}\n";
            objektMail.Content += $"Ukupna cijena: {ukupnaCijena.ToString("0.00")} KM\n\n";
            objektMail.Content += "Hvala vam što koristite CinemaConnect. Želimo vam ugodan boravak u kinu!\n\n";
            objektMail.Content += "Srdačan pozdrav,\nVaš CinemaConnect tim";

            try
            {
                _rabbitMQProducer.SendMessage(objektMail);
                Thread.Sleep(TimeSpan.FromSeconds(15));
            }
            catch (Exception ex)
            {
                // Handle or log the exception
            }
        }

        public async Task<KorisniciView> LoginAdminAsync(KorisniciLogin login)
        {
            var user = await _context.Korisnicis
                .Where(x => x.KorisnickoIme == login.KorisnickoIme)
                .Include(t => t.TipGledatelja)
                .FirstOrDefaultAsync();

            if (user != null)
            {
                if (VerifyPassword(login.Lozinka, user.Lozinka, user.Salt))
                {
                    if (user.TipGledatelja.NazivTipa == "Admin")
                    {
                        var korisnikView = _mapper.Map<KorisniciView>(user);
                        korisnikView.Tip = _mapper.Map<TipGledatelja>(user.TipGledatelja);
                        return korisnikView;
                    }
                }
            }

            return null;
        }
    }
}
