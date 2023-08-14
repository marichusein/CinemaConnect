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
    public class MappingMeniGrickalica : Profile
    {
        public MappingMeniGrickalica()
        {
            CreateMap<Database.MeniGrickalica, Model.ViewRequests.MeniGrickalicaView>();
            CreateMap<MeniGrickalicaInsert, Database.MeniGrickalica>();
            CreateMap<MeniGrickalicaUpdate, Database.MeniGrickalica>();
        }
    }
}
