using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Persistence.Provider;
using Dapper;
using System.Data;
using Persistence.Entity;
using Persistence.Entity.Builder;

namespace Persistence.Gateway
{
    public class ProfileGateway : IProfileGateway
    {
        private readonly IDbProvider provider;
        public ProfileGateway(IDbProvider provider)
        {
            this.provider = provider;
        }

        public void Add(string email, string nickname, int gender, string city, string password, int? godFatherId)
        {
            using (var context = provider.Create())
            { 
                var p = new
                {
                    email = email,
                    nickname = nickname,
                    gender = gender,
                    city = city,
                    password = password,
                    godFatherIdFk = godFatherId
                };

                context
                    .Execute("Profile.AddProfile", p, commandType: CommandType.StoredProcedure);
            }
        }

        public void Activate(int id)
        {
            using (var context = provider.Create())
            {
                context
                    .Execute("Profile.ActivateProfile", new { id = id}, commandType: CommandType.StoredProcedure);
            }
        }

        public void Delete(int id)
        {
            using (var context = provider.Create())
            {
                context
                    .Execute("Profile.DeleteProfile", new { id = id }, commandType: CommandType.StoredProcedure);
            }
        }

        public bool CheckEmail(string email)
        {
            using (var context = provider.Create())
            {
                return context
                    .Query<bool>("Profile.CheckEmail", new { email = email }, commandType: CommandType.StoredProcedure)
                    .First();
            }
        }

        public dynamic GetById(int id)
        {
            using (var context = provider.Create())
            {
                return context
                        .Query("Profile.GetById", new { id = id }, commandType: CommandType.StoredProcedure)
                        .FirstOrDefault();

                
            }
        }
    }
}
