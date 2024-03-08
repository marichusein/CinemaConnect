using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
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
        public List<ProjekcijeView> GetAktivneProjekcije();
        Model.ViewRequests.ProjekcijeView AddProjekciju(ProjekcijeInsert projekcijaInsert);
        Model.ViewRequests.ProjekcijeView UpdateProjekciju(int id, ProjekcijeUpdate projekcijeUpdate);
        Model.ViewRequests.ProjekcijeView GetById(int id);
        bool DeleteById(int id);
        List<Model.ViewRequests.ProjekcijeView> GetByFilm(int id);
        List<Model.ViewRequests.SjedistaViewProjekcija> GetSjedistaByProjekcija(int projekcijaID);


    }
}
