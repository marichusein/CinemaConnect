using AutoMapper;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
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

            if (novaRezervacija.MeniGrickalica != null && novaRezervacija.MeniGrickalica!=0)
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

    }
}
