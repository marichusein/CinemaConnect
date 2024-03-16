using AutoMapper;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Mapping
{
    public class MappingRecommender : Profile
    {
        public MappingRecommender()
        {
            CreateMap<Database.Recommender, Model.ViewRequests.RecommenderView>();
            CreateMap<Model.ViewRequests.RecommenderView, Database.Recommender>();
            CreateMap<RecommenderInsert, Database.Recommender>();
            CreateMap<RecommenderUpdate, Database.Recommender>();
        }
    }
}
