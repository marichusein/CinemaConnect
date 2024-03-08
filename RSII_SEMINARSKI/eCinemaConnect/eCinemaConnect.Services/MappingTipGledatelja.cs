using AutoMapper;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services
{
    public class MappingTipGledatelja : Profile
    {
        public MappingTipGledatelja()
        {
            CreateMap<Database.TipoviGledatelja, Model.TipGledatelja>();
            CreateMap<Model.TipGledatelja, Database.TipoviGledatelja>();

            CreateMap<TipGledateljaInsert, Database.TipoviGledatelja>();
            CreateMap<TipGledateljaUpdate, Database.TipoviGledatelja>();

        }
    }
}
