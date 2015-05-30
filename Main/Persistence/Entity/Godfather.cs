using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Persistence.Entity
{
    public class Godfather
    {
        public readonly int id;
        public readonly string nickname;
        public readonly Gender gender;
        public readonly string city;

        public Godfather(int id, string nickname, int gender, string city)
        {
            this.id = id;
            this.nickname = nickname;
            this.gender = (Gender)gender;
            this.city = city;
        }
    }
}
