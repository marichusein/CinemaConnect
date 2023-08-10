using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class Glumci
{
    public int Idglumca { get; set; }

    public string? Ime { get; set; }

    public string? Prezime { get; set; }

    public byte[]? Slika { get; set; }

    public virtual ICollection<GlumciFilmovi> GlumciFilmovis { get; set; } = new List<GlumciFilmovi>();
}
