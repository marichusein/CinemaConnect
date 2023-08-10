using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class Sjedistum
{
    public int Idsjedista { get; set; }

    public int? SalaId { get; set; }

    public int? BrojSjedista { get; set; }

    public bool? Popunjeno { get; set; }

    public virtual ICollection<ProjekcijeSjedistum> ProjekcijeSjedista { get; set; } = new List<ProjekcijeSjedistum>();

    public virtual Sale? Sala { get; set; }
}
