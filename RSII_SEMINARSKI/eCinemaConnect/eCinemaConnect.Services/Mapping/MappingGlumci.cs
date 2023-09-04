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
    public class MappingGlumci : Profile
    {
        public MappingGlumci()
        {
            CreateMap<Database.Glumci, Model.ViewRequests.GlumciView>();
            CreateMap<Model.ViewRequests.GlumciView, Database.Glumci>();
            CreateMap<GlumciInsert, Database.Glumci>();
            CreateMap<GlumciUpdate, Database.Glumci>();
        }
    }
}
