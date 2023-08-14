using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IMeniGrickalica
    {
        List<Model.ViewRequests.MeniGrickalicaView> GetAll();
        Model.ViewRequests.MeniGrickalicaView AddMeni(MeniGrickalicaInsert meniInsert);
        Model.ViewRequests.MeniGrickalicaView UpdateMeni(int id, MeniGrickalicaUpdate meniUpdate);
        Model.ViewRequests.MeniGrickalicaView GetById(int id);
        bool DeleteById(int id);
    }
}
