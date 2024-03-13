using System.Collections.Generic;
using System.Threading.Tasks;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;

namespace eCinemaConnect.Services.Interface
{
    public interface IFilmovi
    {
        Task<List<FilmoviView>> GetAll();
        Task<List<FilmoviView>> GetSve();

        Task<FilmoviView> AddFilm(FilmoviInsert filmoviInsert);
        Task<FilmoviView> UpdateFilma(int id, FilmoviUpdate filmoviUpdate);
        Task<FilmoviView> GetById(int id);
        Task<bool> DeleteById(int id);
        Task<bool> IzbirsiFilm(int id);
        Task<bool> AktivirajFilm(int id);

        Task<List<FilmoviView>> GetFilmoviByReziser(int id);
        Task<List<FilmoviView>> GetFilmoviByGlumac(int id);
        Task<List<FilmoviView>> GetFilmoviByZanr(int id);
        Task<List<FilmoviView>> GetFilmoviByMultipleFilters(int? zanrid, int? glumacid, int? reziserid);

        Task<List<FilmoviView>> GetPreprukuByKorisnikID(int korisnikid);
    }
}
