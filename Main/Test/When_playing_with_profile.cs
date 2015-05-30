using System;
using System.Dynamic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Persistence.Entity;
using Persistence.Gateway;
using Persistence.Provider;
using Persistence.Repository;

namespace Test
{
    [TestClass]
    public class When_playing_with_profile
    {
        [TestMethod]
        public void When_check_email_exists()
        {
            var mock = new Mock<IProfileGateway>();
            mock.Setup(m => m.CheckEmail(It.IsIn<string>("nicolas.dfr@gmail.com"))).Returns(true);

            var profileRepository = new ProfileRepository(mock.Object);

            var actual = profileRepository.CheckEmail("nicolas.dfr@gmail.com");

            Assert.IsTrue(actual);
        }

        [TestMethod]
        public void When_check_email_not_exists()
        {
            var mock = new Mock<IProfileGateway>();
            mock.Setup(m => m.CheckEmail(It.IsIn<string>("nicolas.dfr@gmail.com"))).Returns(true);

            var profileRepository = new ProfileRepository(mock.Object);

            var actual = profileRepository.CheckEmail("uncknown@gmail.com");

            Assert.IsFalse(actual);
        }

        [TestMethod]
        public void When_get_profile_by_id_exists()
        {
            var date = DateTime.UtcNow;
            var mock = new Mock<IProfileGateway>();

            var obj = GetDynProfile(1, "nicolas.dfr@gmail.com", "dublow", "paris", date, null, null, null);
            mock.Setup(m => m.GetById(It.IsIn<int>(1))).Returns(obj);

            var profileRepository = new ProfileRepository(mock.Object);

            var actual = profileRepository.GetById(1);

            Assert.AreEqual(1, actual.id);
            Assert.AreEqual("nicolas.dfr@gmail.com", actual.email);
            Assert.AreEqual("dublow", actual.nickname);
            Assert.AreEqual("paris", actual.city);
            Assert.AreEqual(date, actual.creation);
            Assert.IsFalse(actual.isActive);
            Assert.IsNull(actual.instagram);
            Assert.IsNull(actual.godfather);
        }

        private object GetDynProfile(int id, string email, string nickname, string city, DateTime creation, 
            DateTime? activation, int? instagramId, int? godfatherId)
        {
            dynamic d = new ExpandoObject();
            d.Id = id;
            d.Email = email;
            d.Nickname = nickname;
            d.Gender = 1;
            d.City = city;
            d.Creation = creation;
            d.Activation = activation;
            d.InstagramId = instagramId;
            d.GodfatherId = godfatherId;

            return d;
        }

        private object GetDynInstagram()
        {
            return null;
        }

        private object GetDynGodfather()
        {
            return null;
        }
    }
}
