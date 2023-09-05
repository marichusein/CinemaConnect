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
    public class MappingKorisnici : Profile
    {
        public MappingKorisnici()
        {
            CreateMap<Database.Korisnici, Model.ViewRequests.KorisniciView>();
            CreateMap<Model.ViewRequests.KorisniciView, Database.Korisnici>();
            CreateMap<KorisniciLogin, Database.Korisnici>();
            CreateMap<KorisniciRegistration, Database.Korisnici>();


            CreateMap<KorisniciInsert, Database.Korisnici>();
            CreateMap<KorisniciUpdate, Database.Korisnici>();
        }
    }
}
