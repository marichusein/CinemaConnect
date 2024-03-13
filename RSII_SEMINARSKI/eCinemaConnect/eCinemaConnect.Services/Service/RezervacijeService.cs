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
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Service
{
    public class RezervacijeService : BaseService<RezervacijaView, RezervacijaInsert, RezervacijaUpdate, Rezervacije, Rezervacije>, IRezervacije
    {
        private readonly CinemaContext _context;
        private readonly IMapper _mapper;

        public RezervacijeService(CinemaContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<RezervacijaView> KreirajRezervacijuAsync(RezervacijaInsert novaRezervacija)
        {
            var newR = _mapper.Map<Database.Rezervacije>(novaRezervacija);
            newR.Usao = false;
            _context.Add(newR);
            await _context.SaveChangesAsync();

            var projekcijaIds = novaRezervacija.odabranaSjedista.Select(s => s.Idsjedista).ToList();
            var projekcijeSjedista = await _context.ProjekcijeSjedista
                .Where(s => projekcijaIds.Contains((int)s.SjedisteId))
                .ToListAsync();

            foreach (var projekcijaSjediste in projekcijeSjedista)
            {
                projekcijaSjediste.Slobodno = false;
            }

            await _context.SaveChangesAsync();

            if (novaRezervacija.MeniGrickalica != null && novaRezervacija.MeniGrickalica != 0)
            {
                var rezervacijgricklaice = new RezervacijeMeniGrickalica()
                {
                    RezervacijaId = newR.Idrezervacije,
                    MeniGrickalicaId = novaRezervacija.MeniGrickalica
                };
                _context.Add(rezervacijgricklaice);
                await _context.SaveChangesAsync();
            }

            return _mapper.Map<RezervacijaView>(newR);
        }

        public async Task<Dictionary<string, int>> BrojKupljenihKarataPoFilmuAsync(DateTime? datumOd, DateTime? datumDo)
        {
            IQueryable<Rezervacije> rezervacijeQuery = _context.Rezervacijes;

            if (datumOd.HasValue && datumDo.HasValue)
            {
                rezervacijeQuery = rezervacijeQuery.Where(r => r.Projekcija != null && r.Projekcija.DatumVrijemeProjekcije >= datumOd && r.Projekcija.DatumVrijemeProjekcije <= datumDo);
            }

            var rezervacijePoFilmu = await rezervacijeQuery
                .Where(r => r.Kupljeno==true && r.Projekcija != null && r.Projekcija.Film != null)
                .GroupBy(r => r.Projekcija.Film.NazivFilma)
                .Select(g => new { Film = g.Key, BrojKarata = g.Sum(r => r.BrojRezervisanihKarata ?? 0) })
                .ToDictionaryAsync(x => x.Film, x => x.BrojKarata);

            return rezervacijePoFilmu;
        }

        public async Task<Dictionary<string, int>> ZaradaOdFilmovaAsync(DateTime? datumOd, DateTime? datumDo)
        {
            IQueryable<Rezervacije> rezervacijeQuery = _context.Rezervacijes;

            if (datumOd.HasValue && datumDo.HasValue)
            {
                rezervacijeQuery = rezervacijeQuery.Where(r => r.Projekcija != null && r.Projekcija.DatumVrijemeProjekcije >= datumOd && r.Projekcija.DatumVrijemeProjekcije <= datumDo);
            }

            var zaradaPoFilmu = await rezervacijeQuery
                .Where(r => r.Kupljeno==true && r.Projekcija != null && r.Projekcija.Film != null)
                .GroupBy(r => r.Projekcija.Film.NazivFilma)
                .Select(g => new { Film = g.Key, Zarada = g.Sum(r => (r.BrojRezervisanihKarata ?? 0) * (r.Projekcija.CijenaKarte ?? 0)) })
                .ToDictionaryAsync(x => x.Film, x => (int)x.Zarada);

            return zaradaPoFilmu;
        }

        public async Task<List<RezervacijaView>> AktivneRezervacijeByKorisnikAsync(int id)
        {
            var rezervacije = await _context.Rezervacijes.Include(p => p.Projekcija)
                .Where(x => x.KorisnikId == id && x.Projekcija.DatumVrijemeProjekcije >= DateTime.Now)
                .ToListAsync();
            return _mapper.Map<List<RezervacijaView>>(rezervacije);
        }

        public async Task<List<RezervacijaView>> NeaktivneRezervacijeByKorisnikAsync(int id)
        {
            var rezervacije = await _context.Rezervacijes.Include(p => p.Projekcija)
                .Where(x => x.KorisnikId == id && x.Projekcija.DatumVrijemeProjekcije <= DateTime.Now)
                .ToListAsync();
            return _mapper.Map<List<RezervacijaView>>(rezervacije);
        }

        public async Task<Dictionary<string, int>> BrojProdatihKarataPoZanruAsync()
        {
            var brojKarataPoZanru = await _context.Rezervacijes
                .Where(r => r.Kupljeno==true && r.Projekcija != null && r.Projekcija.Film != null && r.Projekcija.Film.Zanr != null)
                .GroupBy(r => r.Projekcija.Film.Zanr.NazivZanra)
                .Select(g => new { Zanr = g.Key, BrojKarata = g.Sum(r => r.BrojRezervisanihKarata ?? 0) })
                .ToDictionaryAsync(x => x.Zanr, x => x.BrojKarata);

            return brojKarataPoZanru;
        }

        public async Task OznaciRezervacijuKaoUslaAsync(int rezervacijaId)
        {
            var rezervacija = await _context.Rezervacijes.FirstOrDefaultAsync(r => r.Idrezervacije == rezervacijaId);

            if (rezervacija != null)
            {
                if (rezervacija.Usao==true)
                {
                    throw new Exception($"Ulazak za rezervaciju s ID-om {rezervacijaId} već je registriran.");
                }
                else
                {
                    rezervacija.Usao = true;
                    await _context.SaveChangesAsync();
                }
            }
            else
            {
                throw new Exception($"Rezervacija s ID-om {rezervacijaId} nije pronađena.");
            }
        }
    }
}
