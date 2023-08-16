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
    public class ZanroviService : BaseService<ZanroviView, ZanroviInsert, ZanroviUpdate, Zanrovi, Zanrovi>, IZanrovi
    {
      
        public ZanroviService(CinemaContext context, IMapper mapper): base(context, mapper)
        {
         
        }

        
    }
}
