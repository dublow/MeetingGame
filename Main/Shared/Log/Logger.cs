using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shared.Log
{
    public class Logger 
    {
        public readonly string name;
        public readonly Exception exception;
        public readonly DateTime now;

        public Logger(string name, Exception exception)
        {
            this.name = name;
            this.exception = exception;
            this.now = DateTime.UtcNow;
        }
    }
}
