using eCinemaConnect.Model;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services
{
    public interface ITipGledatelja
    {
        List<TipGledatelja> GetAll();
        Model.TipGledatelja AddTipGledatelja(TipGledateljaInsert tipGledatelja);
        Model.TipGledatelja UpdateTipGledatelja(int id, TipGledateljaUpdate tipGledatelja);

        bool DeleteById(int id);

    }
}
