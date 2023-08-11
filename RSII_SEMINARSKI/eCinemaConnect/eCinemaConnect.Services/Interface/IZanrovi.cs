using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IZanrovi
    {
        List<Model.ViewRequests.ZanroviView> GetAll();
        Model.ViewRequests.ZanroviView AddZanr(ZanroviInsert zanroviInsert);
        Model.ViewRequests.ZanroviView UpdateZanr(int id, ZanroviUpdate zanroviUpdate);
        Model.ViewRequests.ZanroviView GetById(int id);

        bool DeleteById(int id);
    }
}
