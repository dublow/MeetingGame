using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Persistence.Gateway;
using Shared.Log;
using Shared.Observer;

namespace Persistence.Repository
{
    public class InstagramRepository : Observable<Logger>, IInstagramRepository
    {
        private readonly IInstagramGateway gateway;
        public InstagramRepository(IInstagramGateway gateway)
        {
            this.gateway = gateway;
        }

        public void Add(int userId, string profilePicture, string accessToken, int profileId)
        {
            try
            {
                gateway.Add(userId, profilePicture, accessToken, profileId);
            }
            catch (Exception e)
            {
                this.Notify(new Logger("InstagramRepository.Add", e));
                throw;
            }
        }
    }
}
