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
    public interface IFilmovi
    {
        List<Model.ViewRequests.FilmoviView> GetAll();
        Model.ViewRequests.FilmoviView AddFilm(FilmoviInsert filmoviInsert);
        Model.ViewRequests.FilmoviView UpdateFilma(int id, FilmoviUpdate filmoviUpdate);
        Model.ViewRequests.FilmoviView GetById(int id);
        bool DeleteById(int id);
        List<Model.ViewRequests.FilmoviView> GetFilmoviByReziser(int id);
        List<Model.ViewRequests.FilmoviView> GetFilmoviByGlumac(int id);
        List<Model.ViewRequests.FilmoviView> GetFilmoviByZanr(int id);
        List<Model.ViewRequests.FilmoviView> GetFilmoviByMultipleFilters(int? zanrid, int? glumacid, int? reziserid);

    }
}
