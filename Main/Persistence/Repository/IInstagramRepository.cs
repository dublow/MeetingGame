﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Persistence.Repository
{
    public interface IInstagramRepository
    {
        void Add(int userId, string profilePicture, string accessToken, int profileId);
    }
}
