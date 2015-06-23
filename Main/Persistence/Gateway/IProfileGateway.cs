using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Persistence.Entity;

namespace Persistence.Gateway
{
    public interface IProfileGateway
    {
        void Add(string email, string nickname, int gender, string city, string password, int? godFatherId);
        void Activate(int id);
        void Delete(int id);

        bool CheckEmail(string email);
        dynamic GetById(int id);
        dynamic GetCredential(string email);
    }
}
