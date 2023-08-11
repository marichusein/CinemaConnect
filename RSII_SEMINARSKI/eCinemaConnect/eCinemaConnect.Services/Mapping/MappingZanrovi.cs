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
    public class MappingZanrovi : Profile
    {
        public MappingZanrovi()
        {
            CreateMap<Database.Zanrovi, Model.ViewRequests.ZanroviView>();
            CreateMap<ZanroviInsert, Database.Zanrovi>();
            CreateMap<ZanroviUpdate, Database.Zanrovi>();
        }
    }
}
