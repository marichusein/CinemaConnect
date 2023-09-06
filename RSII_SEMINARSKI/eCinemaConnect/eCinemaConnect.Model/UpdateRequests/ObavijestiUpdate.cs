using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Model.UpdateRequests
{
    public class ObavijestiUpdate
    {
        public string? Naslov { get; set; }

        public string? Sadrzaj { get; set; }

        public DateTime? DatumUredjivanja { get; set; }
    }
}
