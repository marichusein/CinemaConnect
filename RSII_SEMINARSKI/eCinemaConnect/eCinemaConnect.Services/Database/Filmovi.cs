using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class Filmovi
{
    public int Idfilma { get; set; }

    public string? NazivFilma { get; set; }

    public int? ZanrId { get; set; }

    public string? Opis { get; set; }

    public int? Trajanje { get; set; }

    public int? GodinaIzdanja { get; set; }

    public int? ReziserId { get; set; }

    public string? PlakatFilma { get; set; }

    public virtual ICollection<GlumciFilmovi> GlumciFilmovis { get; set; } = new List<GlumciFilmovi>();

    public virtual ICollection<OcjeneIkomentari> OcjeneIkomentaris { get; set; } = new List<OcjeneIkomentari>();

    public virtual ICollection<Projekcije> Projekcijes { get; set; } = new List<Projekcije>();

    public virtual ICollection<Recenzije> Recenzijes { get; set; } = new List<Recenzije>();

    public virtual Reziseri? Reziser { get; set; }

    public virtual Zanrovi? Zanr { get; set; }
}
