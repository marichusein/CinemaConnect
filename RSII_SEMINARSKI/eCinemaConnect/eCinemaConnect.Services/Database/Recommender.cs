using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class Recommender
{

    public int Id { get; set; }
    public int FilmId { get; set; }
    public int CoFilmId1 { get; set; }
    public int CoFilmId2 { get; set; }
    public int CoFilmId3 { get; set; }
}

