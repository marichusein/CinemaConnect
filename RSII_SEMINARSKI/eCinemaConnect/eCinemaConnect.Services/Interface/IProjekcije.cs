using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IProjekcije
    {
        List<Model.ViewRequests.ProjekcijeView> GetAll();
        Model.ViewRequests.ProjekcijeView AddProjekciju(ProjekcijeInsert projekcijaInsert);
        Model.ViewRequests.ProjekcijeView UpdateProjekciju(int id, ProjekcijeUpdate projekcijeUpdate);
        Model.ViewRequests.ProjekcijeView GetById(int id);
        bool DeleteById(int id);
        List<Model.ViewRequests.ProjekcijeView> GetByFilm(int id);

    }
}
