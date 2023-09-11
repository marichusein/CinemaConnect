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
    public class MappingOcijeniFilm : Profile
    {
        public MappingOcijeniFilm()
        {
            CreateMap<Database.OcjeneIkomentari, Model.ViewRequests.OcijeniFilmView>();
            CreateMap<Model.ViewRequests.OcijeniFilmView, Database.OcjeneIkomentari>();
            CreateMap<OcijeniFilmUpdate, Database.OcjeneIkomentari>();
            CreateMap<OcijeniFilmInsert, Database.OcjeneIkomentari>();
        }
    }
}
