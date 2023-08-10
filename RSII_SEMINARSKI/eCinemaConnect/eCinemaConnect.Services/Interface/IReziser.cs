using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IReziser
    {
        List<Model.ViewRequests.ReziseriView> GetAll();
        Model.ViewRequests.ReziseriView AddRezisera(ReziserInsert reziserInsert);
        Model.ViewRequests.ReziseriView UpdateRezisera(int id, ReziserUpdate reziserUpdate);

        bool DeleteById(int id);
    }
}
