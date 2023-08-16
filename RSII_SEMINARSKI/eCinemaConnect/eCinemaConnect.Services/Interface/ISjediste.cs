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
    public interface ISjediste : IService<SjedistaView, SjedistaInsert, SjedistaUpdate>
    {
        public SjedistaView GetById(int id);

        public SjedistaView AddSpecial(SjedistaInsert sjedistaInsert);
        public List<SjedistaView> GetAllWithPovezanoSvojstvo();
        public List<SjedistaView> GetAllBySala(int id);

    }
}
