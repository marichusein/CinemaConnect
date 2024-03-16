using AutoMapper;
using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML.Trainers;
using Microsoft.ML;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eCinemaConnect.Model;
using System.Runtime.CompilerServices;

namespace eCinemaConnect.Services.Service
{
    public class RecommenderService : BaseService<RecommenderView, RecommenderInsert, RecenzijeUpdate, Recommender, Recommender>, IRecommender
    {
        private readonly CinemaContext _context;
        private readonly IMapper _mapper;
        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;
        public RecommenderService(CinemaContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public Task<RecommenderView> UpdateObjAsync(int id, RecommenderUpdate Update)
        {
            throw new NotImplementedException();
        }
        public List<Model.ViewRequests.FilmoviView> Recommend(int id)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var tmpData = _context.OcjeneIkomentaris.Take(17).ToList();
                    Console.WriteLine(tmpData.Count);

                    var data = new List<FilmoviPreporuka>();

                    foreach (var x in tmpData)
                    {
                        data.Add(new FilmoviPreporuka()
                        {
                            FilmID = (uint)x.FilmId,
                            KorisnikID = (uint)x.KorisnikId,
                            Ocjena = (float)x.Ocjena
                        });
                    }

                    var trainData = mlContext.Data.LoadFromEnumerable(data);
                    var rowCount = trainData.GetRowCount();

                    if (rowCount > 0)
                    {
                        Console.WriteLine("Data loaded successfully. Row count: " + rowCount);
                    }
                    else
                    {
                        Console.WriteLine("No data loaded. Row count: " + rowCount);
                    };
                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options
                    {
                        MatrixColumnIndexColumnName = nameof(FilmoviPreporuka.FilmID),
                        MatrixRowIndexColumnName = nameof(FilmoviPreporuka.KorisnikID),
                        LabelColumnName = nameof(FilmoviPreporuka.Ocjena),
                        NumberOfIterations = 20,
                        ApproximationRank = 100
                    };


                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model = est.Fit(trainData);
                }
            }
            var predictionengine = mlContext.Model.CreatePredictionEngine<FilmoviPreporuka, CoFilmovi_prediction>(model);

            var ocijenjeniFilmovi = _context.OcjeneIkomentaris
                                            .Where(x => x.KorisnikId == id)
                                            .Select(x => x.FilmId)
                                            .ToList();

            var filmoviNijeOcijenio = _context.Filmovis
                                        .Where(f => !ocijenjeniFilmovi.Contains(f.Idfilma))
                                        .ToList();

            var predvidjeneOcjene = new List<Tuple<Database.Filmovi, float>>();

            foreach (var film in filmoviNijeOcijenio)
            {
                var movieratingprediction = predictionengine.Predict(
                    new FilmoviPreporuka()
                    {
                        KorisnikID = (uint)id,
                        FilmID = (uint)film.Idfilma
                    }
                );

               
                predvidjeneOcjene.Add(Tuple.Create(film, movieratingprediction.Score));
            }

           
            predvidjeneOcjene = predvidjeneOcjene.OrderByDescending(x => x.Item2).Take(3).ToList();

          
            var recommendedFilms = _context.Filmovis
                                        .Where(f => predvidjeneOcjene.Select(r => r.Item1.Idfilma).Contains(f.Idfilma))
                                        .ToList();

        
            var recommendedFilmViewModels = _mapper.Map<List<FilmoviView>>(recommendedFilms);



            return recommendedFilmViewModels;

        }
        public async Task<List<Model.ViewRequests.RecommenderView>> TrainModelAsync(CancellationToken cancellationToken = default)
        {
            var korisnici = await _context.Korisnicis.ToListAsync(cancellationToken);
            var brojOcjena = await _context.OcjeneIkomentaris.CountAsync(cancellationToken);

            if (korisnici.Count() > 4 && brojOcjena > 8)
            {
                List<Database.Recommender> recommendList = new List<Database.Recommender>();

                foreach (var korisnik in korisnici)
                {
                    var recommendedFilms = Recommend(korisnik.Idkorisnika);

                    var resultRecommend = new Database.Recommender()
                    {
                        KorisnikId = korisnik.Idkorisnika,
                        CoFilmId1 = recommendedFilms[0].Idfilma,
                        CoFilmId2 = recommendedFilms[1].Idfilma,
                        CoFilmId3 = recommendedFilms[2].Idfilma
                    };
                    recommendList.Add(resultRecommend);
                }

                await CreateNewRecommendation(recommendList, cancellationToken);
                await _context.SaveChangesAsync(cancellationToken);

                return _mapper.Map<List<Model.ViewRequests.RecommenderView>>(recommendList);
            }
            else
            {
                throw new Exception("Not enough data to make recommendations.");
            }
        }



        public async Task CreateNewRecommendation(List<Database.Recommender> results, CancellationToken cancellationToken = default)
        {
            var existingRecommendations = await _context.Recommenders.ToListAsync(cancellationToken);
            var filmCount = await _context.Filmovis.CountAsync(cancellationToken);
            var recordCount = existingRecommendations.Count;

            if (recordCount != 0)
            {
                if (recordCount > filmCount)
                {
                    for (int i = 0; i < filmCount; i++)
                    {
                        existingRecommendations[i].KorisnikId = results[i].KorisnikId;
                        existingRecommendations[i].CoFilmId1 = results[i].CoFilmId1;
                        existingRecommendations[i].CoFilmId2 = results[i].CoFilmId2;
                        existingRecommendations[i].CoFilmId3 = results[i].CoFilmId3;
                    }

                    for (int i = filmCount; i < recordCount; i++)
                    {
                        _context.Recommenders.Remove(existingRecommendations[i]);
                    }
                }
                else
                {
                    for (int i = 0; i < recordCount; i++)
                    {
                        existingRecommendations[i].KorisnikId = results[i].KorisnikId;
                        existingRecommendations[i].CoFilmId1 = results[i].CoFilmId1;
                        existingRecommendations[i].CoFilmId2 = results[i].CoFilmId2;
                        existingRecommendations[i].CoFilmId3 = results[i].CoFilmId3;
                    }

                    var numToAdd = results.Count - recordCount;
                    if (numToAdd > 0)
                    {
                        await _context.Recommenders.AddRangeAsync(results.Skip(recordCount).Take(numToAdd), cancellationToken);
                    }
                }
            }
            else
            {
                await _context.Recommenders.AddRangeAsync(results, cancellationToken);
            }

            await _context.SaveChangesAsync(cancellationToken);
        }
        public async Task DeleteAllRecommendation(CancellationToken cancellationToken = default)
        {
            await _context.Recommenders.ExecuteDeleteAsync(cancellationToken);
        }

        public class CoFilmovi_prediction
        {
            public float Score { get; set; }
        }
    }
}
