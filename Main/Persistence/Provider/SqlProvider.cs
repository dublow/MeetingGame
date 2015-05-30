using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Persistence.Provider
{
    public class SqlProvider : IDbProvider
    {
        private readonly string cnx;
        public SqlProvider(string cnx)
        {
            this.cnx = cnx;
        }

        public IDbConnection Create()
        {
            return new SqlConnection(cnx);
        }
    }
}
