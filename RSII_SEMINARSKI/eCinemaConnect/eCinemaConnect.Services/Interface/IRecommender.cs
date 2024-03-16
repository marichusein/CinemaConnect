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
    public interface IRecommender: IService<RecommenderView, RecommenderInsert, RecommenderUpdate>
    {
        public List<Model.ViewRequests.FilmoviView> Recommend(int id);
        Task<List<Model.ViewRequests.RecommenderView>> TrainModelAsync(CancellationToken cancellationToken = default);
    }
}
