using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Practices.Unity;
using Persistence.Gateway;
using Persistence.Provider;
using Persistence.Repository;
using Shared.Log;


namespace Console
{
    class Program
    {
        static void Main(string[] args)
        {
            var cnx = ConfigurationManager.ConnectionStrings["MeetingGame"].ConnectionString;
            var provider = new SqlProvider(cnx);

            var container = new UnityContainer();

            container
                .RegisterInstance<IDbProvider>(provider)
                .RegisterType<IProfileGateway, ProfileGateway>()
                .RegisterType<IInstagramGateway, InstagramGateway>()
                .RegisterType<IProfileRepository, ProfileRepository>()
                .RegisterType<IInstagramRepository, InstagramRepository>();

            var profileRepo = container.Resolve<ProfileRepository>();
            var instagramRepo = container.Resolve<InstagramRepository>();
            profileRepo.Subscribe(new ConsoleLogger());
            instagramRepo.Subscribe(new ConsoleLogger());

            //profileRepo.Add("nicolas.dfr1@gmail.com", "dublow", 1, "Paris", "password", null);
            //instagramRepo.Add(123, "http://instagram-picture.com", "azer1234", 21);

            var p = profileRepo.GetById(25);
        }
    }
}
