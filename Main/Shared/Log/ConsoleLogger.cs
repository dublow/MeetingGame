using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shared.Log
{
    public class ConsoleLogger : IObserver<Logger>
    {
        public void OnCompleted()
        {
            Console.WriteLine("OnCompleted");
        }

        public void OnError(Exception error)
        {
            Console.WriteLine("OnError: {0}", error.Message);
        }

        public void OnNext(Logger value)
        {
            Console.WriteLine("Date: {0}", value.now);
            Console.WriteLine("Name: {0}", value.name);
            Console.WriteLine("Message: {0}", value.exception.Message);
        }
    }
}
