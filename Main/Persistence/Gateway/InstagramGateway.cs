using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Persistence.Provider;
using Dapper;
using System.Data;

namespace Persistence.Gateway
{
    public class InstagramGateway : IInstagramGateway
    {
        private readonly IDbProvider provider;
        public InstagramGateway(IDbProvider provider)
        {
            this.provider = provider;
        }

        public void Add(int userId, string profilePicture, string accessToken, int profileId)
        {
            using (var context = provider.Create())
            {
                var p = new {
                    userId = userId,
                    profilePicture = profilePicture,
                    accessToken = accessToken,
                    profileId = profileId
                };

                context.Execute("Instagram.AddInstagram", p, commandType: CommandType.StoredProcedure);
            }
        }
    }
}
