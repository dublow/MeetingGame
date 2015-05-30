using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Persistence.Entity
{
    public class Instagram
    {
        public readonly int id;
        public readonly string accessToken;
        public readonly long userId;
        public readonly string profilePicture;

        public Instagram(int id, string accessToken, long userId, string profilePicture)
        {
            this.id = id;
            this.accessToken = accessToken;
            this.userId = userId;
            this.profilePicture = profilePicture;
        }
    }
}
