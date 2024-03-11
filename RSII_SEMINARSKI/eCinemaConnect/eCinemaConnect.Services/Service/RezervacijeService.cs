using AutoMapper;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Service
{
    public class RezervacijeService : BaseService<RezervacijaView, RezervacijaInsert, RezervacijaUpdate, Rezervacije, Rezervacije>, IRezervacije
    {
        CinemaContext _context;
        IMapper _mapper;
        public RezervacijeService(CinemaContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public RezervacijaView KreirajRezervaciju(RezervacijaInsert novaRezervacija)
        {
            var newR = _mapper.Map<Database.Rezervacije>(novaRezervacija);
            newR.Usao = false;
            _context.Add(newR);
            _context.SaveChanges();

            var projekcijaIds = novaRezervacija.odabranaSjedista.Select(s => s.Idsjedista).ToList();
            var projekcijeSjedista = _context.ProjekcijeSjedista
                .Where(s => projekcijaIds.Contains((int)s.SjedisteId))
                .ToList();

            foreach (var projekcijaSjediste in projekcijeSjedista)
            {
                projekcijaSjediste.Slobodno = false;
            }

            _context.SaveChanges();

            if (novaRezervacija.MeniGrickalica != null && novaRezervacija.MeniGrickalica != 0)
            {
                var rezervacijgricklaice = new RezervacijeMeniGrickalica()
                {
                    RezervacijaId = newR.Idrezervacije,
                    MeniGrickalicaId = novaRezervacija.MeniGrickalica
                };
                _context.Add(rezervacijgricklaice);
                _context.SaveChanges();
            }

            return _mapper.Map<RezervacijaView>(newR);
        }


        

        public Dictionary<string, int> BrojKupljenihKarataPoFilmu(DateTime? datumOd, DateTime? datumDo)
        {
            IQueryable<Rezervacije> rezervacijeQuery = _context.Rezervacijes;

            if (datumOd.HasValue && datumDo.HasValue)
            {
                rezervacijeQuery = rezervacijeQuery.Where(r => r.Projekcija != null && r.Projekcija.DatumVrijemeProjekcije >= datumOd && r.Projekcija.DatumVrijemeProjekcije <= datumDo);
            }

            var rezervacijePoFilmu = rezervacijeQuery
                .Where(r => r.Kupljeno == true && r.Projekcija != null && r.Projekcija.Film != null)
                .GroupBy(r => r.Projekcija.Film.NazivFilma)
                .Select(g => new { Film = g.Key, BrojKarata = g.Sum(r => r.BrojRezervisanihKarata ?? 0) })
                .ToDictionary(x => x.Film, x => x.BrojKarata);

            return rezervacijePoFilmu;
        }

        public Dictionary<string, int> ZaradaOdFilmova(DateTime? datumOd, DateTime? datumDo)
        {
            IQueryable<Rezervacije> rezervacijeQuery = _context.Rezervacijes;

            if (datumOd.HasValue && datumDo.HasValue)
            {
                rezervacijeQuery = rezervacijeQuery.Where(r => r.Projekcija != null && r.Projekcija.DatumVrijemeProjekcije >= datumOd && r.Projekcija.DatumVrijemeProjekcije <= datumDo);
            }

            var zaradaPoFilmu = rezervacijeQuery
                .Where(r => r.Kupljeno == true && r.Projekcija != null && r.Projekcija.Film != null)
                .GroupBy(r => r.Projekcija.Film.NazivFilma)
                .Select(g => new { Film = g.Key, Zarada = g.Sum(r => (r.BrojRezervisanihKarata ?? 0) * (r.Projekcija.CijenaKarte ?? 0)) })
                .ToDictionary(x => x.Film, x => (int)x.Zarada);

            return zaradaPoFilmu;
        }

        public List<RezervacijaView> AktivneRezervacijeByKorisnik(int id)
        {
            var rezervacije = _context.Rezervacijes.Include(p => p.Projekcija).Where(x => x.KorisnikId == id).Where(p=>p.Projekcija.DatumVrijemeProjekcije>=DateTime.Now).ToList();
            return _mapper.Map<List<RezervacijaView>>(rezervacije);
        }

        public List<RezervacijaView> NeaktivneRezervacijeByKorisnik(int id)
        {
            var rezervacije = _context.Rezervacijes.Include(p => p.Projekcija).Where(x => x.KorisnikId == id).Where(p => p.Projekcija.DatumVrijemeProjekcije <= DateTime.Now).ToList();
            return _mapper.Map<List<RezervacijaView>>(rezervacije);
        }

        public Dictionary<string, int> BrojProdatihKarataPoZanru()
        {
            var brojKarataPoZanru = _context.Rezervacijes
                .Where(r => r.Kupljeno == true && r.Projekcija != null && r.Projekcija.Film != null && r.Projekcija.Film.Zanr != null)
                .GroupBy(r => r.Projekcija.Film.Zanr.NazivZanra)
                .Select(g => new { Zanr = g.Key, BrojKarata = g.Sum(r => r.BrojRezervisanihKarata ?? 0) })
                .ToDictionary(x => x.Zanr, x => x.BrojKarata);

            return brojKarataPoZanru;
        }

        public void OznaciRezervacijuKaoUsla(int rezervacijaId)
        {
            var rezervacija = _context.Rezervacijes.FirstOrDefault(r => r.Idrezervacije == rezervacijaId);

            if (rezervacija != null)
            {
                if (rezervacija.Usao==true)
                {
                    throw new Exception($"Ulazak za rezervaciju s ID-om {rezervacijaId} već je registriran.");
                }
                else
                {
                    rezervacija.Usao = true;
                    _context.SaveChanges();
                }
            }
            else
            {
                throw new Exception($"Rezervacija s ID-om {rezervacijaId} nije pronađena.");
            }
        }

        


    }
}
