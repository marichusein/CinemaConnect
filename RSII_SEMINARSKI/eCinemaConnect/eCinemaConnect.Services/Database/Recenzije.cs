using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class Recenzije
{
    public int Idrecenzije { get; set; }

    public int? FilmId { get; set; }

    public string? NaslovRecenzije { get; set; }

    public string? SadrzajRecenzije { get; set; }

    public DateTime? DatumObjave { get; set; }

    public virtual Filmovi? Film { get; set; }
}
