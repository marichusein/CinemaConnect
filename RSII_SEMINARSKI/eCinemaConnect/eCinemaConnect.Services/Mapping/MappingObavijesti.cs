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
    public class MappingObavijesti : Profile
    {
        public MappingObavijesti()
        {
            CreateMap<Database.Obavijesti, Model.ViewRequests.ObavijestiView>();
            CreateMap<Model.ViewRequests.ObavijestiView, Database.Obavijesti>();
            CreateMap<ObavijestiInsert, Database.Obavijesti>();
            CreateMap<ObavijestiUpdate, Database.Obavijesti>();
        }
    }
}
