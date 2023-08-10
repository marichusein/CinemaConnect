using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class ProjekcijeSjedistum
{
    public int Id { get; set; }

    public int? ProjekcijaId { get; set; }

    public int? SjedisteId { get; set; }

    public bool? Slobodno { get; set; }

    public virtual Projekcije? Projekcija { get; set; }

    public virtual Sjedistum? Sjediste { get; set; }
}
