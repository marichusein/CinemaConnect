using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IRecenzije: IService<RecenzijeView, RecenzijeInsert, RecenzijeUpdate>
    {
        public RecenzijeView GetById(int id);

        public RecenzijeView AddRecenziju(RecenzijeInsert recenzijeInsert);
        public List<RecenzijeView> GetAllWithPovezanoSvojstvo();
    }
}
