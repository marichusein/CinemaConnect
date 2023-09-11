﻿using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Model.UpdateRequests;
using eCinemaConnect.Model.ViewRequests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eCinemaConnect.Services.Interface
{
    public interface IOcijeni: IService<OcijeniFilmView, OcijeniFilmInsert, OcijeniFilmUpdate>
    {
        double getProsjekZaFilm(int idfilma);
    }
}
