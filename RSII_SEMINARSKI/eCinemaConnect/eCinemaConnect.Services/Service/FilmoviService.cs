using AutoMapper;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Service
{
    public class FilmoviService : IFilmovi
    {
        private readonly CinemaContext _context;
        private readonly IMapper _mapper;
        private readonly IReziser _reziseri;
        private readonly IZanrovi _zanrovi;
        private readonly IOcijeni _ocijeni;

        public FilmoviService(CinemaContext context, IMapper mapper, IReziser reziseri, IZanrovi zanrovi, IOcijeni ocijeni)
        {
            _context = context;
            _mapper = mapper;
            _reziseri = reziseri;
            _zanrovi = zanrovi;
            _ocijeni = ocijeni;
        }

        public async Task<FilmoviView> AddFilm(FilmoviInsert filmoviInsert)
        {
            var newFilm = new Database.Filmovi();
            _mapper.Map(filmoviInsert, newFilm);
            newFilm.Reziser = await _context.Reziseris.FindAsync(filmoviInsert.ReziserId);
            newFilm.Zanr = await _context.Zanrovis.FindAsync(filmoviInsert.ZanrId);
            newFilm.Aktivan = true;

            _context.Add(newFilm);
            await _context.SaveChangesAsync();

            if (filmoviInsert.glumciUFlimu != null)
            {
                foreach (GlumciView g in filmoviInsert.glumciUFlimu)
                {
                    var glumacBaza = _mapper.Map<Glumci>(g);
                    var newFilmoviGlumic = new GlumciFilmovi()
                    {
                        FilmId = newFilm.Idfilma,
                        GlumacId = glumacBaza.Idglumca
                    };
                    _context.GlumciFilmovis.Add(newFilmoviGlumic);
                }
                await _context.SaveChangesAsync();
            }

            return _mapper.Map<FilmoviView>(newFilm);
        }

        public async Task<bool> DeleteById(int id)
        {
            try
            {
                var glumciFilmovi = await _context.GlumciFilmovis
                                  .Where(x => x.FilmId == id)
                                  .ToListAsync();
                _context.GlumciFilmovis.RemoveRange(glumciFilmovi);
                await _context.SaveChangesAsync();
                var filmtodelete = await _context.Filmovis.FindAsync(id);

                _context.Filmovis.Remove(filmtodelete);
                await _context.SaveChangesAsync();
            }
            catch
            {
                return false;
            }
            return true;
        }

        public async Task<List<FilmoviView>> GetAll()
        {
            var filmovi = await _context.Filmovis.Include(z => z.Zanr).Include(r => r.Reziser).Where(x => x.Aktivan == true).ToListAsync();
            return _mapper.Map<List<FilmoviView>>(filmovi);
        }

        public async Task<FilmoviView> GetById(int id)
        {
            var filmovi = await _context.Filmovis.Include(z => z.Zanr).Include(r => r.Reziser).ToListAsync();
            var film = filmovi.Where(x => x.Idfilma == id).FirstOrDefault();
            return _mapper.Map<FilmoviView>(film);
        }

        public async Task<bool> IzbirsiFilm(int id)
        {
            var film = await _context.Filmovis
                                .Include(z => z.Zanr)
                                .Include(r => r.Reziser)
                                .FirstOrDefaultAsync(x => x.Idfilma == id);

            if (film != null)
            {
                film.Aktivan = false;
                await _context.SaveChangesAsync();
                return true;
            }
            else
            {
                return false;
            }
        }

        public async Task<List<FilmoviView>> GetFilmoviByGlumac(int id)
        {
            var glumciFilmovi = await _context.GlumciFilmovis.Where(x => x.GlumacId == id).Select(x => x.FilmId).ToListAsync();
            var filmovi = await _context.Filmovis.Where(f => glumciFilmovi.Contains(f.Idfilma)).Include(z => z.Zanr).Include(r => r.Reziser).ToListAsync();
            return _mapper.Map<List<FilmoviView>>(filmovi);
        }

        public async Task<List<FilmoviView>> GetFilmoviByReziser(int id)
        {
            var filmovi = await _context.Filmovis.Include(z => z.Zanr).Include(r => r.Reziser).ToListAsync();
            filmovi = filmovi.Where(x => x.ReziserId == id).ToList();
            return _mapper.Map<List<FilmoviView>>(filmovi);
        }

        public async Task<List<FilmoviView>> GetFilmoviByZanr(int id)
        {
            var filmovi = await _context.Filmovis.Include(z => z.Zanr).Include(r => r.Reziser).ToListAsync();
            filmovi = filmovi.Where(x => x.ZanrId == id).ToList();
            return _mapper.Map<List<FilmoviView>>(filmovi);
        }

        public async Task<List<FilmoviView>> GetFilmoviByMultipleFilters(int? zanrid, int? glumacid, int? reziserid)
        {
            var filmovi = await _context.Filmovis.Include(z => z.Zanr).Include(r => r.Reziser).ToListAsync();

            if (zanrid.HasValue)
            {
                filmovi = filmovi.Where(f => f.ZanrId == zanrid.Value).ToList();
            }

            if (glumacid.HasValue)
            {
                var glumciFilmovi = await _context.GlumciFilmovis
                                      .Where(x => x.GlumacId == glumacid.Value)
                                      .Select(x => x.FilmId)
                                      .ToListAsync();
                filmovi = filmovi.Where(f => glumciFilmovi.Contains(f.Idfilma)).ToList();
            }

            if (reziserid.HasValue)
            {
                filmovi = filmovi.Where(f => f.ReziserId == reziserid.Value).ToList();
            }

            return _mapper.Map<List<FilmoviView>>(filmovi);
        }

        public async Task<FilmoviView> UpdateFilma(int id, FilmoviUpdate filmoviUpdate)
        {
            var film = await _context.Filmovis.FindAsync(id);

            if (film != null)
            {
                _mapper.Map(filmoviUpdate, film);
                await _context.SaveChangesAsync();
            }

            return _mapper.Map<FilmoviView>(film);
        }

        public async Task<List<FilmoviView>> GetPreprukuByKorisnikID(int korisnikId)
        {
            var ocjeneKorisnika = await _context.OcjeneIkomentaris
                .Where(x => x.KorisnikId == korisnikId)
                .ToListAsync();

            if (ocjeneKorisnika.Count == 0)
            {
                // Ako korisnik nije ocijenio nijedan film, vrati praznu listu
                return new List<FilmoviView>();
            }

            var filmoviKorisnika = ocjeneKorisnika.Select(x => x.FilmId).ToList();

            // Izračunaj matricu sličnosti korisnika
            var matricaSlicnosti = new Dictionary<int, double>(); // KorisnikId, Slicnost
            foreach (var filmId in filmoviKorisnika)
            {
                var korisniciKojiSuOceniliFilm = await _context.OcjeneIkomentaris
                    .Where(x => x.FilmId == filmId && x.KorisnikId != korisnikId)
                    .Select(x => x.KorisnikId)
                    .Distinct()
                    .ToListAsync();

                foreach (var korisnik in korisniciKojiSuOceniliFilm)
                {
                    if (!matricaSlicnosti.ContainsKey((int)korisnik))
                        matricaSlicnosti[(int)korisnik] = 0;

                    matricaSlicnosti[(int)korisnik] += 1; // Možete koristiti neki drugi metod za izračunavanje sličnosti
                }
            }

            // Sortiraj korisnike po sličnosti i odaberi najslinih 5
            var slicniKorisnici = matricaSlicnosti
                .OrderByDescending(kv => kv.Value)
                .Take(5)
                .Select(kv => kv.Key)
                .ToList();

            // Generiraj preporuke na temelju sličnih korisnika
            var preporuceniFilmovi = new List<int?>();
            if (slicniKorisnici.Count > 0)
            {
                preporuceniFilmovi = await _context.OcjeneIkomentaris
                    .Where(x => slicniKorisnici.Contains((int)x.KorisnikId) && x.Ocjena > 3)
                    .GroupBy(x => x.FilmId)
                    .OrderByDescending(g => g.Count())
                    .Select(g => g.Key)
                    .Take(10)
                    .ToListAsync();
            }
            else
            {
                // Ako nema dovoljno sličnih korisnika, pronađi po dva najbolje ocijenjena filma
                var ocjenePoFilmu = await _context.OcjeneIkomentaris
                    .Where(x => x.KorisnikId != korisnikId && filmoviKorisnika.Contains(x.FilmId))
                    .GroupBy(x => x.FilmId)
                    .Select(g => new { FilmId = g.Key, ProsjecnaOcjena = g.Average(x => x.Ocjena) })
                    .OrderByDescending(x => x.ProsjecnaOcjena)
                    .Take(2)
                    .Select(x => x.FilmId)
                    .ToListAsync();

                preporuceniFilmovi.AddRange((IEnumerable<int?>)ocjenePoFilmu);
            }

            var preporuceniFilmoviDetalji = await _context.Filmovis
                .Where(x => preporuceniFilmovi.Contains(x.Idfilma))
                .Include(z => z.Zanr)
                .Include(r => r.Reziser)
                .ToListAsync();

            var preporuceniFilmoviView = _mapper.Map<List<FilmoviView>>(preporuceniFilmoviDetalji);

            return preporuceniFilmoviView;
        }

        public async Task<List<FilmoviView>> GetSve()
        {
            var filmovi = await _context.Filmovis.Include(z => z.Zanr).Include(r => r.Reziser).ToListAsync();
            return _mapper.Map<List<FilmoviView>>(filmovi);
        }

        public async Task<bool> AktivirajFilm(int id)
        {
            var film = await _context.Filmovis
                                .Include(z => z.Zanr)
                                .Include(r => r.Reziser)
                                .FirstOrDefaultAsync(x => x.Idfilma == id);

            if (film != null)
            {
                film.Aktivan = true;
                await _context.SaveChangesAsync();
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
