using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.ViewRequests;

using eCinemaConnect.Model.UpdateRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface ISale: IService<SalaView, SaleInsert, SalaUpdate>
    {
       
    }
}
