using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class ProjekcijeRepertoari
{
    public int Id { get; set; }

    public int? ProjekcijaId { get; set; }

    public int? RepertoarId { get; set; }

    public virtual Projekcije? Projekcija { get; set; }

    public virtual Repertoari? Repertoar { get; set; }
}
