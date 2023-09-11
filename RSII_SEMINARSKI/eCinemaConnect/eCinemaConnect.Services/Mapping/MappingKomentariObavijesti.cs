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
    public class MappingKomentariObavijesti:Profile
    {
        public MappingKomentariObavijesti()
        {
            CreateMap<Database.KomentariObavijesti, Model.ViewRequests.KomentariObavijestiView>();
            CreateMap<Model.ViewRequests.GlumciView, Database.KomentariObavijesti>();
            CreateMap<KomentariObavijestiInsert, Database.KomentariObavijesti>();
            CreateMap<KomentariObavijestiUpdate, Database.KomentariObavijesti>();
        }
    }
}
