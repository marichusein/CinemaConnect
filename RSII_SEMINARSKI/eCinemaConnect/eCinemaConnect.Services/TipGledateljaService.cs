using AutoMapper;
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
    public class TipGledateljaService : ITipGledatelja {
        CinemaContext context1;
        public IMapper _mapper { get; set; }
        public TipGledateljaService(CinemaContext context, IMapper mapper)
        {
            context1 = context;
            _mapper = mapper;
        }

        public List<TipGledatelja> GetAll()
        {
            return _mapper.Map<List<Model.TipGledatelja>>(context1.TipoviGledateljas.ToList());
        }

        public TipGledatelja AddTipGledatelja(TipGledateljaInsert tipGledatelja)
        {
            var newTipGledatelja = new Database.TipoviGledatelja();
            _mapper.Map(tipGledatelja, newTipGledatelja);
            context1.Add(newTipGledatelja);
            context1.SaveChanges();

            return _mapper.Map<TipGledatelja>(newTipGledatelja);
        }

        public TipGledatelja UpdateTipGledatelja(int id, TipGledateljaUpdate tipGledatelja)
        {
            var objektIzBaze = context1.TipoviGledateljas.Find(id);
            _mapper.Map(tipGledatelja, objektIzBaze);
            context1.SaveChanges();
            return _mapper.Map<Model.TipGledatelja>(objektIzBaze);
        }

        public bool DeleteById(int id)
        {
            var objektIzBaze = context1.TipoviGledateljas.Find(id);

            if (objektIzBaze != null)
            {
                context1.TipoviGledateljas.Remove(objektIzBaze);
                context1.SaveChanges();
                return true;
            }

            return false;
        }
    }
}
