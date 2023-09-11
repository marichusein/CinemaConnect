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
    public class ProjekcijeService : IProjekcije
    {
        CinemaContext _context;
        public IMapper _mapper { get; set; }
        public ISjediste _sjedista { get; set; }
        public ProjekcijeService(CinemaContext context, IMapper mapper, ISjediste sjedista)
        {
            _context = context;
            _mapper = mapper;
            _sjedista = sjedista;
        }

        public ProjekcijeView AddProjekciju(ProjekcijeInsert projekcijaInsert)
        {
            var newProjekcija = new Database.Projekcije();
            _mapper.Map(projekcijaInsert, newProjekcija);
            _context.Add(newProjekcija);
            _context.SaveChanges();

            var sjedista=_sjedista.GetAllBySala((int)projekcijaInsert.SalaId);
            for (int i = 0; i < sjedista.Count; i++)
            {
                var projekcijasjediste = new Database.ProjekcijeSjedistum();
                projekcijasjediste.SjedisteId = sjedista[i].Idsjedista;
                projekcijasjediste.ProjekcijaId = newProjekcija.Idprojekcije;
                projekcijasjediste.Slobodno = true;
                _context.Add(projekcijasjediste);
                _context.SaveChanges();
            }

           
            

            return _mapper.Map<ProjekcijeView>(newProjekcija);
        }

        public bool DeleteById(int id)
        {
            var objektIzBaze = _context.Projekcijes.Find(id);

            if (objektIzBaze != null)
            {
                _context.Projekcijes.Remove(objektIzBaze);
                _context.SaveChanges();
                return true;
            }

            return false;
        }

        public List<ProjekcijeView> GetAll()
        {
            var projekcije = _context.Projekcijes.Include(f => f.Film).Include(f=>f.Film.Zanr).Include(f=>f.Film.Reziser).Include(s=>s.Sala).ToList();
            return _mapper.Map<List<ProjekcijeView>>(projekcije);
        }

        public List<ProjekcijeView> GetByFilm(int id)
        {
            var projekcije = _context.Projekcijes.Include(f => f.Film).Include(f => f.Film.Zanr).Include(f => f.Film.Reziser).Include(s => s.Sala).ToList();
            projekcije = projekcije.Where(x=>x.FilmId== id).ToList();
            return _mapper.Map<List<ProjekcijeView>>(projekcije);
        }

        public ProjekcijeView GetById(int id)
        {
            var projekcija = _context.Projekcijes.Find(id);
            return _mapper.Map<ProjekcijeView>(projekcija);
        }

        public ProjekcijeView UpdateProjekciju(int id, ProjekcijeUpdate projekcijeUpdate)
        {
            var existingProjekcija = _context.Projekcijes.Find(id);
            if (existingProjekcija != null)
            {
                _mapper.Map(projekcijeUpdate, existingProjekcija);
                _context.SaveChanges();
                return _mapper.Map<ProjekcijeView>(existingProjekcija);
            }
            return null;
        }
    }
}
