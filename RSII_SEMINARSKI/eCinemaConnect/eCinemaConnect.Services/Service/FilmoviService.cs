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
        public FilmoviService(CinemaContext context, IMapper mapper, IReziser reziseri, IZanrovi zanrovi)
        {
            _context = context;
            _mapper = mapper;
            _reziseri = reziseri;
            _zanrovi = zanrovi;
        }
        public FilmoviView AddFilm(FilmoviInsert filmoviInsert)
        {
            var newFilm = new Database.Filmovi();
            _mapper.Map(filmoviInsert, newFilm);
            newFilm.Reziser = _context.Reziseris.Find(filmoviInsert.ReziserId);
            newFilm.Zanr = _context.Zanrovis.Find(filmoviInsert.ZanrId);


            _context.Add(newFilm);
            _context.SaveChanges();
            if(filmoviInsert.glumciUFlimu != null) {
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
            var filmovi = _context.Filmovis.Include(z => z.Zanr).Include(r => r.Reziser).ToList();
            return _mapper.Map<List<FilmoviView>>(filmovi);
        }

        public FilmoviView GetById(int id)
        {
            var filmovi = _context.Filmovis.Include(z => z.Zanr).Include(r => r.Reziser).ToList();
            var film = filmovi.Where(x => x.Idfilma == id).FirstOrDefault();
            return _mapper.Map<FilmoviView>(film);

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
    }
}
