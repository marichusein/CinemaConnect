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
    public class MappingSjedista: Profile
    {
        public MappingSjedista()
        {
            CreateMap<Database.Sjedistum, Model.ViewRequests.SjedistaView>();
            CreateMap<SjedistaInsert, Database.Sjedistum>();
            CreateMap<SjedistaUpdate, Database.Sjedistum>();
        }
    }
}
