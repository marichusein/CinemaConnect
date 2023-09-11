using AutoMapper;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Mapping
{
    public class MappingRezervacije: Profile
    {
        public MappingRezervacije()
        {
            CreateMap<Database.Rezervacije, Model.ViewRequests.RezervacijaView>();
            CreateMap<Model.ViewRequests.RezervacijaView, Database.Rezervacije>();
            CreateMap<RezervacijaInsert, Database.Rezervacije>();
            CreateMap<RezervacijaUpdate, Database.Rezervacije>();
        }
    }
}
