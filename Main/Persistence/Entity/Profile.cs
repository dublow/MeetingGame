using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Persistence.Entity
{
    public class Profile
    {
        public readonly int id;
        public readonly string email;
        public readonly string nickname;
        public readonly Gender gender;
        public readonly string city;
        public readonly DateTime creation;
        public readonly bool isActive;
        public readonly Instagram instagram;
        public readonly Godfather godfather;

        public Profile(int id, string email, string nickname, int gender, string city, DateTime creation, 
            DateTime? activation, Instagram instagram, Godfather godfather)
        {
            this.id = id;
            this.email = email;
            this.nickname = nickname;
            this.gender = (Gender)gender;
            this.city = city;
            this.creation = creation;
            this.isActive = activation.HasValue;
            this.instagram = instagram;
            this.godfather = godfather;
        }
    }
}
