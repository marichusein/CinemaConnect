using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IGlumci
    {

        List<Model.ViewRequests.GlumciView> GetAll();
        Model.ViewRequests.GlumciView AddGlumca(GlumciInsert glumciInsert);
        Model.ViewRequests.GlumciView UpdateGlumca(int id, GlumciUpdate reziserUpdate);

        bool DeleteById(int id);
    }
}
