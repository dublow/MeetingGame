using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Persistence.Entity.Builder
{
    public class ProfileBuilder
    {
        private readonly int id;
        private readonly string email;
        private readonly string nickname;
        private readonly int gender;
        private readonly string city;
        private readonly DateTime creation;
        private readonly DateTime? activation;
        private GodfatherBuilder godfatherBuilder;
        private InstagramBuilder instagramBuilder;

        private ProfileBuilder(int id, string email, string nickname, int gender, string city, DateTime creation, DateTime? activation)
        {
            this.id = id;
            this.email = email;
            this.nickname = nickname;
            this.gender = gender;
            this.city = city;
            this.creation = creation;
            this.activation = activation;
        }

        public static ProfileBuilder Create(int id, string email, string nickname, int gender, string city, DateTime creation, DateTime? activation)
        {
            return new ProfileBuilder(id, email, nickname, gender, city, creation, activation);
        }

        public ProfileBuilder AddGodfather(int id, string nickname, int gender, string city)
        {
            this.godfatherBuilder = GodfatherBuilder.Create(id, nickname, gender, city);
            return this;
        }

        public ProfileBuilder AddInstagram(int id, string accessToken, long userId, string profilePicture)
        {
            this.instagramBuilder = InstagramBuilder.Create(id, accessToken, userId, profilePicture);
            return this;
        }

        public Profile Build()
        {
            return new Profile(id, email, nickname, gender, city, creation, activation, 
                (Instagram)instagramBuilder, (Godfather)godfatherBuilder);
        }
    }
}
