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
    public class MappingReziseri : Profile
    {
        public MappingReziseri()
        {
            CreateMap<Database.Reziseri, Model.ViewRequests.ReziseriView>();
            CreateMap<ReziserInsert, Database.Reziseri>();
            CreateMap<ReziserUpdate, Database.Reziseri>();
        }
    }
}
