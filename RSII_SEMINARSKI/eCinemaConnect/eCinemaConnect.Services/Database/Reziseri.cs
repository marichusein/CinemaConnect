using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class Reziseri
{
    public int Idrezisera { get; set; }

    public string? Ime { get; set; }

    public string? Prezime { get; set; }

    public virtual ICollection<Filmovi> Filmovis { get; set; } = new List<Filmovi>();
}
