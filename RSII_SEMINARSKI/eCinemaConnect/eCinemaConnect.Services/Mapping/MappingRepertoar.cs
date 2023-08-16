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
    internal class MappingRepertoar: Profile
    {
        public MappingRepertoar()
        {
            CreateMap<Database.Repertoari, Model.ViewRequests.RepertoarView>();
            CreateMap<RepertoarInsert, Database.Repertoari>();
            CreateMap<RepertoarUpdate, Database.Repertoari>();
        }
    }
}
