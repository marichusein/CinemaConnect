using AutoMapper;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Service
{
    public class ObavijestiService : BaseService<ObavijestiView, ObavijestiInsert, ObavijestiUpdate, Obavijesti, Obavijesti>, IObavijesti
    {
        public ObavijestiService(CinemaContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
