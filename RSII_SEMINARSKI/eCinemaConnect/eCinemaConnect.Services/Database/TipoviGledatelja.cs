using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class TipoviGledatelja
{
    public int Idtipa { get; set; }

    public string? NazivTipa { get; set; }

    public virtual ICollection<Korisnici> Korisnicis { get; set; } = new List<Korisnici>();
}
