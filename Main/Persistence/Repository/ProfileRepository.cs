using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Persistence.Entity;
using Persistence.Entity.Builder;
using Persistence.Gateway;
using Shared.Cryptography;
using Shared.Log;
using Shared.Observer;

namespace Persistence.Repository
{
    public class ProfileRepository : Observable<Logger>, IProfileRepository 
    {
        private readonly IProfileGateway gateway;
        public ProfileRepository(IProfileGateway gateway)
        {
            this.gateway = gateway;
        }

        public void Add(string email, string nickname, int gender, string city, string password, int? godFatherId)
        {
            try
            {
                gateway.Add(email, nickname, gender, city, PasswordHash.CreateHash(password), godFatherId);
            }
            catch (Exception e)
            {
                this.Notify(new Logger("ProfileRepository.Add", e));
                throw;
            }
        }

        public void Activate(int id)
        {
            try
            {
                gateway.Activate(id);
            }
            catch (Exception e)
            {
                this.Notify(new Logger("ProfileRepository.Activate", e));
                throw;
            }
        }

        public void Delete(int id)
        {
            try
            {
                gateway.Delete(id);
            }
            catch (Exception e)
            {
                this.Notify(new Logger("ProfileRepository.Delete", e));
                throw;
            }
            
        }

        public bool CheckEmail(string email)
        {
            try
            {
                return gateway.CheckEmail(email);
            }
            catch (Exception e)
            {
                this.Notify(new Logger("ProfileRepository.CheckEmail", e));
                throw;
            }
        }

        public Profile GetById(int id)
        {
            try
            {
                var dynProfile = gateway.GetById(id);

                if (dynProfile == null)
                    return null;

                var p = ProfileBuilder
                    .Create(
                        dynProfile.Id, dynProfile.Email, dynProfile.Nickname, dynProfile.Gender,
                        dynProfile.City, dynProfile.Creation, dynProfile.Activation);

                if (dynProfile.InstagramId != null)
                    p.AddInstagram(dynProfile.InstagramId, dynProfile.AccessToken, dynProfile.InstagramUserId, dynProfile.ProfilePicture);

                if (dynProfile.GodfatherId != null)
                    p.AddGodfather(dynProfile.GodfatherId, dynProfile.GodfatherNickname, dynProfile.GodfatherGender, dynProfile.GodfatherCity);

                return p.Build();
            }
            catch (Exception e)
            {
                this.Notify(new Logger("ProfileRepository.GetById", e));
                throw;
            }
        }

        public Credential GetCredential(string email, string password)
        {
            try
            {
                var dynCredential = gateway.GetCredential(email);

                if (dynCredential == null)
                    return null;

                if (!PasswordHash.ValidatePassword(password, dynCredential.Password))
                    return null;

                return new Credential(dynCredential.Id, email);
            }
            catch (Exception e)
            {
                this.Notify(new Logger("ProfileRepository.GetCredential", e));
                throw;
            }
        }
    }
}
