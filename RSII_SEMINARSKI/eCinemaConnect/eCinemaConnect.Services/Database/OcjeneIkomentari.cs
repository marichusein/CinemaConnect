using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class OcjeneIkomentari
{
    public int Idocjene { get; set; }

    public int? KorisnikId { get; set; }

    public int? FilmId { get; set; }

    public int? Ocjena { get; set; }

    public string? Komentar { get; set; }

    public DateTime? DatumOcjene { get; set; }

    public virtual Filmovi? Film { get; set; }

    public virtual Korisnici? Korisnik { get; set; }
}
