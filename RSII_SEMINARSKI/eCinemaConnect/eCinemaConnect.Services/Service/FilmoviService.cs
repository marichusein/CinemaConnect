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
    public class FilmoviService : IFilmovi
    {
        CinemaContext _context;
        public IMapper _mapper { get; set; }
        public IReziser _reziseri { get; set; }
        public IZanrovi _zanrovi { get; set; }
        public IOcijeni _ocijeni { get; set; }
        public FilmoviService(CinemaContext context, IMapper mapper, IReziser reziseri, IZanrovi zanrovi, IOcijeni ocijeni)
        {
            _context = context;
            _mapper = mapper;
            _reziseri = reziseri;
            _zanrovi = zanrovi;
            _ocijeni = ocijeni;
        }
        public FilmoviView AddFilm(FilmoviInsert filmoviInsert)
        {
            var newFilm = new Database.Filmovi();
            _mapper.Map(filmoviInsert, newFilm);
            newFilm.Reziser = _context.Reziseris.Find(filmoviInsert.ReziserId);
            newFilm.Zanr = _context.Zanrovis.Find(filmoviInsert.ZanrId);
            newFilm.Aktivan = true;


            _context.Add(newFilm);
            _context.SaveChanges();
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
                    _context.SaveChanges();
                }
            }


            return _mapper.Map<FilmoviView>(newFilm);
        }

        public bool DeleteById(int id)
        {
            try
            {
                var glumciFilmovi = _context.GlumciFilmovis
                                  .Where(x => x.FilmId == id)
                                  .ToList();
                _context.GlumciFilmovis.RemoveRange(glumciFilmovi);
                _context.SaveChanges();
                var filmtodelete = _context.Filmovis.Find(id);

                _context.Filmovis.Remove(filmtodelete);
                _context.SaveChanges();
            }
            catch
            {
                return false;
            }
            return true;

        }

        public List<FilmoviView> GetAll()
        {
            var filmovi = _context.Filmovis.Include(z => z.Zanr).Include(r => r.Reziser).Where(x=>x.Aktivan==true).ToList();
            return _mapper.Map<List<FilmoviView>>(filmovi);
        }

        public FilmoviView GetById(int id)
        {
            var filmovi = _context.Filmovis.Include(z => z.Zanr).Include(r => r.Reziser).ToList();
            var film = filmovi.Where(x => x.Idfilma == id).FirstOrDefault();
            return _mapper.Map<FilmoviView>(film);

        }

        public bool IzbirsiFilm(int id)
        {
            var film = _context.Filmovis
                                .Include(z => z.Zanr)
                                .Include(r => r.Reziser)
                                .FirstOrDefault(x => x.Idfilma == id);

            if (film != null)
            {
                film.Aktivan = false;
                _context.SaveChanges();
                return true;
            }
            else
            {
                return false; // Film with the given id was not found
            }
        }


        public List<FilmoviView> GetFilmoviByGlumac(int id)
        {
            var glumciFilmovi = _context.GlumciFilmovis.Where(x => x.GlumacId == id).Select(x => x.FilmId).ToList();
            var filmovi = _context.Filmovis.Where(f => glumciFilmovi.Contains(f.Idfilma)).Include(z => z.Zanr).Include(r => r.Reziser).ToList();
            return _mapper.Map<List<FilmoviView>>(filmovi);
        }

        public List<FilmoviView> GetFilmoviByReziser(int id)
        {
            var filmovi = _context.Filmovis.Include(z => z.Zanr).Include(r => r.Reziser).ToList();
            filmovi = filmovi.Where(x => x.ReziserId == id).ToList();
            return _mapper.Map<List<FilmoviView>>(filmovi);
        }

        public List<FilmoviView> GetFilmoviByZanr(int id)
        {
            var filmovi = _context.Filmovis.Include(z => z.Zanr).Include(r => r.Reziser).ToList();
            filmovi = filmovi.Where(x => x.ZanrId == id).ToList();
            return _mapper.Map<List<FilmoviView>>(filmovi);
        }
        public List<FilmoviView> GetFilmoviByMultipleFilters(int? zanrid, int? glumacid, int? reziserid)
        {
            var filmovi = _context.Filmovis.Include(z => z.Zanr).Include(r => r.Reziser).ToList();

            if (zanrid.HasValue)
            {
                filmovi = filmovi.Where(f => f.ZanrId == zanrid.Value).ToList();
            }

            if (glumacid.HasValue)
            {
                var glumciFilmovi = _context.GlumciFilmovis
                                      .Where(x => x.GlumacId == glumacid.Value)
                                      .Select(x => x.FilmId)
                                      .ToList();
                filmovi = filmovi.Where(f => glumciFilmovi.Contains(f.Idfilma)).ToList();
            }

            if (reziserid.HasValue)
            {
                filmovi = filmovi.Where(f => f.ReziserId == reziserid.Value).ToList();
            }

            return _mapper.Map<List<FilmoviView>>(filmovi);
        }

        public FilmoviView UpdateFilma(int id, FilmoviUpdate filmoviUpdate)
        {
            var film = _context.Filmovis.Find(id);

            if (film != null)
            {
                _mapper.Map(filmoviUpdate, film);
                _context.SaveChanges();
            }

            return _mapper.Map<FilmoviView>(film);
        }


        public List<FilmoviView> GetPreprukuByKorisnikID(int korisnikId)
        {
            var ocjeneKorisnika = _context.OcjeneIkomentaris
                .Where(x => x.KorisnikId == korisnikId)
                .ToList();

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
                var korisniciKojiSuOceniliFilm = _context.OcjeneIkomentaris
                    .Where(x => x.FilmId == filmId && x.KorisnikId != korisnikId)
                    .Select(x => x.KorisnikId)
                    .Distinct()
                    .ToList();

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
                preporuceniFilmovi = _context.OcjeneIkomentaris
                    .Where(x => slicniKorisnici.Contains((int)x.KorisnikId) && x.Ocjena > 3)
                    .GroupBy(x => x.FilmId)
                    .OrderByDescending(g => g.Count())
                    .Select(g => g.Key)
                    .Take(10)
                    .ToList();
            }
            else
            {
                // Ako nema dovoljno sličnih korisnika, pronađi po dva najbolje ocijenjena filma
                var ocjenePoFilmu = _context.OcjeneIkomentaris
                    .Where(x => x.KorisnikId != korisnikId && filmoviKorisnika.Contains(x.FilmId))
                    .GroupBy(x => x.FilmId)
                    .Select(g => new { FilmId = g.Key, ProsjecnaOcjena = g.Average(x => x.Ocjena) })
                    .OrderByDescending(x => x.ProsjecnaOcjena)
                    .Take(2)
                    .Select(x => x.FilmId)
                    .ToList();

                preporuceniFilmovi.AddRange((IEnumerable<int?>)ocjenePoFilmu);
            }

            var preporuceniFilmoviDetalji = _context.Filmovis
                .Where(x => preporuceniFilmovi.Contains(x.Idfilma))
                .Include(z => z.Zanr)
                .Include(r => r.Reziser)
                .ToList();

            var preporuceniFilmoviView = _mapper.Map<List<FilmoviView>>(preporuceniFilmoviDetalji);

            return preporuceniFilmoviView;
        }

        public List<FilmoviView> GetSve()
        {
            var filmovi = _context.Filmovis.Include(z => z.Zanr).Include(r => r.Reziser).ToList();
            return _mapper.Map<List<FilmoviView>>(filmovi);
        }

        public bool AktivirajFilm(int id)
        {
            var film = _context.Filmovis
                                .Include(z => z.Zanr)
                                .Include(r => r.Reziser)
                                .FirstOrDefault(x => x.Idfilma == id);

            if (film != null)
            {
                film.Aktivan = true;
                _context.SaveChanges();
                return true;
            }
            else
            {
                return false; 
            }
        }
    }
}
