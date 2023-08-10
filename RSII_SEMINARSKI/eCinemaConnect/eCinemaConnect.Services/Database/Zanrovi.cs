using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class Zanrovi
{
    public int Idzanra { get; set; }

    public string? NazivZanra { get; set; }

    public virtual ICollection<Filmovi> Filmovis { get; set; } = new List<Filmovi>();

    public virtual ICollection<RezervacijeZanrovi> RezervacijeZanrovis { get; set; } = new List<RezervacijeZanrovi>();
}
