using AutoMapper;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Services.Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Mapping
{
    public class MappingSale : Profile
    {
        public MappingSale()
        {
            CreateMap<Database.Sale, Model.ViewRequests.SalaView>();
            CreateMap<SaleInsert, Database.Sale>();
            CreateMap<SalaUpdate, Database.Sale>();
        }
    }
}
