using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface ISale
    {
        List<Model.ViewRequests.SalaView> GetAll();
        Model.ViewRequests.SalaView AddSalu(SaleInsert salaInsert);
        Model.ViewRequests.SalaView UpdateSalu(int id, SalaUpdate salaUpdate);
        Model.ViewRequests.SalaView GetById(int id);

        bool DeleteById(int id);
    }
}
