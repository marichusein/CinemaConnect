using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IService<T, TInsert, TUpdate> where T: class where TInsert: class where TUpdate : class
    {
        List<T> GetAll();
        T AddObj(TInsert Insert);
        T UpdateObj(int id, TUpdate Update);
        T GetObj(int id);

        bool DeleteById(int id);
    }
}
