using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Persistence.Entity.Builder
{
    public class InstagramBuilder
    {
        private readonly int id;
        private readonly string accessToken;
        private readonly long userId;
        private readonly string profilePicture;

        private InstagramBuilder(int id, string accessToken, long userId, string profilePicture)
        {
            this.id = id;
            this.accessToken = accessToken;
            this.userId = userId;
            this.profilePicture = profilePicture;
        }

        public static InstagramBuilder Create(int id, string accessToken, long userId, string profilePicture)
        {
            return new InstagramBuilder(id, accessToken, userId, profilePicture);
        }

        public static explicit operator Instagram(InstagramBuilder instagramBuilder)
        {
            if (instagramBuilder == null)
                return null;

            return new Instagram(instagramBuilder.id, instagramBuilder.accessToken, 
                instagramBuilder.userId, instagramBuilder.profilePicture);
        }
    }
}
