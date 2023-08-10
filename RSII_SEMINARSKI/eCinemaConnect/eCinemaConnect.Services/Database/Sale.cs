using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class Sale
{
    public int Idsale { get; set; }

    public string? NazivSale { get; set; }

    public virtual ICollection<Projekcije> Projekcijes { get; set; } = new List<Projekcije>();

    public virtual ICollection<Sjedistum> Sjedista { get; set; } = new List<Sjedistum>();
}
