using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Persistence.Entity.Builder
{
    public class GodfatherBuilder
    {
        private readonly int id;
        private readonly string nickname;
        private readonly int gender;
        private readonly string city;

        private GodfatherBuilder(int id, string nickname, int gender, string city)
        {
            this.id = id;
            this.nickname = nickname;
            this.gender = gender;
            this.city = city;
        }

        public static GodfatherBuilder Create(int id, string nickname, int gender, string city)
        {
            return new GodfatherBuilder(id, nickname, gender, city);
        }

        public static explicit operator Godfather(GodfatherBuilder godfatherBuilder)
        {
            if (godfatherBuilder == null)
                return null;

            return new Godfather(godfatherBuilder.id, godfatherBuilder.nickname, 
                godfatherBuilder.gender, godfatherBuilder.city);
        }
    }
}
