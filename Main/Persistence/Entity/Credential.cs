using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Persistence.Entity
{
    public class Credential
    {
        public readonly int id;
        public readonly string email;

        public Credential(int id, string email)
        {
            this.id = id;
            this.email = email;
        }
    }
}
