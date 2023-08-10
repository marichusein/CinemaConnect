using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class GlumciFilmovi
{
    public int Id { get; set; }

    public int? FilmId { get; set; }

    public int? GlumacId { get; set; }

    public virtual Filmovi? Film { get; set; }

    public virtual Glumci? Glumac { get; set; }
}
