using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class Repertoari
{
    public int Idrepertoara { get; set; }

    public DateTime? Pocetak { get; set; }

    public DateTime? Kraj { get; set; }

    public string? Opis { get; set; }

    public virtual ICollection<ProjekcijeRepertoari> ProjekcijeRepertoaris { get; set; } = new List<ProjekcijeRepertoari>();
}
