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
    public class MappingProjekcije : Profile
    {
        public MappingProjekcije()
        {
            CreateMap<Database.Projekcije, Model.ViewRequests.ProjekcijeView>();
            CreateMap<ProjekcijeInsert, Database.Projekcije>();
            CreateMap<ProjekcijeUpdate, Database.Projekcije>();
        }
    }
}
