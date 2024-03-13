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
    public class ProjekcijeService : IProjekcije
    {
        private readonly CinemaContext _context;
        private readonly IMapper _mapper;
        private readonly ISjediste _sjedista;

        public ProjekcijeService(CinemaContext context, IMapper mapper, ISjediste sjedista)
        {
            _context = context;
            _mapper = mapper;
            _sjedista = sjedista;
        }

        public async Task<ProjekcijeView> AddProjekcijuAsync(ProjekcijeInsert projekcijaInsert)
        {
            var existingProjekcije = await _context.Projekcijes
                .Where(p => p.SalaId == projekcijaInsert.SalaId &&
                            p.DatumVrijemeProjekcije.Value.Date == projekcijaInsert.DatumVrijemeProjekcije.Value.Date)
                .ToListAsync();

            foreach (var existingProjekcija in existingProjekcije)
            {
                var krajPostojeceProjekcije = existingProjekcija.DatumVrijemeProjekcije.Value.AddMinutes(180);

                if (projekcijaInsert.DatumVrijemeProjekcije >= existingProjekcija.DatumVrijemeProjekcije &&
                    projekcijaInsert.DatumVrijemeProjekcije <= krajPostojeceProjekcije)
                {
                    throw new Exception("Sala je već zauzeta za odabrani datum i vrijeme.");
                }
            }

            var newProjekcija = new Database.Projekcije();
            _mapper.Map(projekcijaInsert, newProjekcija);
            _context.Add(newProjekcija);
            await _context.SaveChangesAsync();

            var sjedista = await _sjedista.GetAllBySalaAsync((int)projekcijaInsert.SalaId);
            foreach (var sjediste in sjedista)
            {
                var projekcijasjediste = new Database.ProjekcijeSjedistum
                {
                    SjedisteId = sjediste.Idsjedista,
                    ProjekcijaId = newProjekcija.Idprojekcije,
                    Slobodno = true
                };
                _context.Add(projekcijasjediste);
            }
            await _context.SaveChangesAsync();

            return _mapper.Map<ProjekcijeView>(newProjekcija);
        }

        public async Task<bool> DeleteByIdAsync(int id)
        {
            var objektIzBaze = await _context.Projekcijes.FindAsync(id);

            if (objektIzBaze != null)
            {
                _context.Projekcijes.Remove(objektIzBaze);
                await _context.SaveChangesAsync();
                return true;
            }

            return false;
        }

        public async Task<List<ProjekcijeView>> GetAllAsync()
        {
            var projekcije = await _context.Projekcijes
                .Include(f => f.Film)
                .Include(f => f.Film.Zanr)
                .Include(f => f.Film.Reziser)
                .Include(s => s.Sala)
                .ToListAsync();

            return _mapper.Map<List<ProjekcijeView>>(projekcije);
        }

        public async Task<List<ProjekcijeView>> GetByFilmAsync(int id)
        {
            var projekcije = await _context.Projekcijes
                .Include(f => f.Film)
                .Include(f => f.Film.Zanr)
                .Include(f => f.Film.Reziser)
                .Include(s => s.Sala)
                .Where(x => x.FilmId == id)
                .ToListAsync();

            return _mapper.Map<List<ProjekcijeView>>(projekcije);
        }

        public async Task<List<ProjekcijeView>> GetByFilmAktivneAsync(int id)
        {
            var trenutakPretrage = DateTime.Now;

            var projekcije = await _context.Projekcijes
                .Include(f => f.Film)
                .Include(f => f.Film.Zanr)
                .Include(f => f.Film.Reziser)
                .Include(s => s.Sala)
                .Where(x => x.FilmId == id && x.DatumVrijemeProjekcije >= trenutakPretrage)
                .ToListAsync();

            return _mapper.Map<List<ProjekcijeView>>(projekcije);
        }

        public async Task<ProjekcijeView> GetByIdAsync(int id)
        {
            var projekcija = await _context.Projekcijes
                .Include(f => f.Film)
                .Include(s => s.Sala)
                .FirstOrDefaultAsync(x => x.Idprojekcije == id);

            return _mapper.Map<ProjekcijeView>(projekcija);
        }

        public async Task<ProjekcijeView> UpdateProjekcijuAsync(int id, ProjekcijeUpdate projekcijeUpdate)
        {
            var existingProjekcija = await _context.Projekcijes.FindAsync(id);

            if (existingProjekcija != null)
            {
                _mapper.Map(projekcijeUpdate, existingProjekcija);
                await _context.SaveChangesAsync();
                return _mapper.Map<ProjekcijeView>(existingProjekcija);
            }

            return null;
        }

        public async Task<List<SjedistaViewProjekcija>> GetSjedistaByProjekcijaAsync(int projekcijaID)
        {
            var projekcija = await _context.ProjekcijeSjedista
                .Where(x => x.ProjekcijaId == projekcijaID)
                .ToListAsync();

            var sjedista = new List<SjedistaViewProjekcija>();

            foreach (var item in projekcija)
            {
                var sjediste = await _context.Sjedista.FindAsync(item.SjedisteId);

                if (sjediste != null)
                {
                    var sjedisteView = new SjedistaViewProjekcija
                    {
                        Idsjedista = sjediste.Idsjedista,
                        Slobodno = item.Slobodno,
                        BrojSjedista = sjediste.BrojSjedista
                    };

                    sjedista.Add(sjedisteView);
                }
            }

            return sjedista;
        }

        public async Task<List<ProjekcijeView>> GetAktivneProjekcijeAsync()
        {
            var trenutakPretrage = DateTime.Now;

            var aktivneProjekcije = await _context.Projekcijes
                .Where(p => p.DatumVrijemeProjekcije > trenutakPretrage)
                .Include(f => f.Film)
                .Include(s => s.Sala)
                .Include(z => z.Film.Zanr)
                .Include(r => r.Film.Reziser)
                .ToListAsync();

            return _mapper.Map<List<ProjekcijeView>>(aktivneProjekcije);
        }
    }
}
