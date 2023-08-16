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
    public class MappingRecenzije : Profile
    {
        public MappingRecenzije()
        {
            CreateMap<Database.Recenzije, Model.ViewRequests.RecenzijeView>();
            CreateMap<RecenzijeInsert, Database.Recenzije>();
            CreateMap<RecenzijeUpdate, Database.Recenzije>();
        }
    }
}
