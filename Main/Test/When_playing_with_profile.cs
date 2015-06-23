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

        [TestMethod]
        public void When_get_profile_with_instagram_by_id_exists()
        {
            var date = DateTime.UtcNow;
            var obj = GetDynProfile(1, "nicolas.dfr@gmail.com", "dublow", "paris", date, null, 1, null);
            obj = GetDynInstagram(obj, "azderfgt", 1234, "http://picture.com");

            var mock = new Mock<IProfileGateway>();
            mock.Setup(m => m.GetById(It.IsIn<int>(1))).Returns(obj);

            var profileRepository = new ProfileRepository(mock.Object);
            var actual = profileRepository.GetById(1);

            Assert.AreEqual(1, actual.id);
            Assert.AreEqual("nicolas.dfr@gmail.com", actual.email);
            Assert.AreEqual("dublow", actual.nickname);
            Assert.AreEqual("paris", actual.city);
            Assert.AreEqual(date, actual.creation);
            Assert.IsFalse(actual.isActive);
            Assert.AreEqual("azderfgt", actual.instagram.accessToken);
            Assert.AreEqual(1, actual.instagram.id);
            Assert.AreEqual("http://picture.com", actual.instagram.profilePicture);
            Assert.AreEqual(1234, actual.instagram.userId);
            Assert.IsNull(actual.godfather);
        }

        [TestMethod]
        public void When_get_profile_with_instagram_and_godfather_by_id_exists()
        {
            var date = DateTime.UtcNow;
            var obj = GetDynProfile(1, "nicolas.dfr@gmail.com", "dublow", "paris", date, null, 1, 2);
            obj = GetDynInstagram(obj, "azderfgt", 1234, "http://picture.com");
            obj = GetDynGodfather(obj, "godfather", 2, "Lyon");

            var mock = new Mock<IProfileGateway>();
            mock.Setup(m => m.GetById(It.IsIn<int>(1))).Returns(obj);

            var profileRepository = new ProfileRepository(mock.Object);
            var actual = profileRepository.GetById(1);

            Assert.AreEqual(1, actual.id);
            Assert.AreEqual("nicolas.dfr@gmail.com", actual.email);
            Assert.AreEqual("dublow", actual.nickname);
            Assert.AreEqual(Gender.Male, actual.gender);
            Assert.AreEqual("paris", actual.city);
            Assert.AreEqual(date, actual.creation);
            Assert.IsFalse(actual.isActive);
            Assert.AreEqual("azderfgt", actual.instagram.accessToken);
            Assert.AreEqual(1, actual.instagram.id);
            Assert.AreEqual("http://picture.com", actual.instagram.profilePicture);
            Assert.AreEqual(1234, actual.instagram.userId);
            Assert.AreEqual(2, actual.godfather.id);
            Assert.AreEqual("godfather", actual.godfather.nickname);
            Assert.AreEqual(Gender.Female, actual.godfather.gender);
            Assert.AreEqual("Lyon", actual.godfather.city);
        }

        [TestMethod]
        public void When_get_profile_with__godfather_by_id_exists()
        {
            var date = DateTime.UtcNow;
            var obj = GetDynProfile(1, "nicolas.dfr@gmail.com", "dublow", "paris", date, null, null, 2);
            obj = GetDynGodfather(obj, "godfather", 2, "Lyon");

            var mock = new Mock<IProfileGateway>();
            mock.Setup(m => m.GetById(It.IsIn<int>(1))).Returns(obj);

            var profileRepository = new ProfileRepository(mock.Object);
            var actual = profileRepository.GetById(1);

            Assert.AreEqual(1, actual.id);
            Assert.AreEqual("nicolas.dfr@gmail.com", actual.email);
            Assert.AreEqual("dublow", actual.nickname);
            Assert.AreEqual(Gender.Male, actual.gender);
            Assert.AreEqual("paris", actual.city);
            Assert.AreEqual(date, actual.creation);
            Assert.IsFalse(actual.isActive);
            Assert.IsNull(actual.instagram);
            Assert.AreEqual(2, actual.godfather.id);
            Assert.AreEqual("godfather", actual.godfather.nickname);
            Assert.AreEqual(Gender.Female, actual.godfather.gender);
            Assert.AreEqual("Lyon", actual.godfather.city);
        }

        [TestMethod]
        public void When_get_credential_success()
        {
            var mock = new Mock<IProfileGateway>();
            mock.Setup(m => m.GetCredential(It.Is<string>(x => x == "nicolas.dfr@gmail.com")))
                .Returns(GetDynCredential(1, "1000:dTPbuVvX/5Sq9R80aPGNlAfYaV2IAyLS:agomX4Lus4uhKRXkdkeMNfe4wQtghh5O"));

            var profileRepository = new ProfileRepository(mock.Object);
            var actual = profileRepository.GetCredential("nicolas.dfr@gmail.com", "password");

            Assert.AreEqual(1, actual.id);
            Assert.AreEqual("nicolas.dfr@gmail.com", actual.email);
        }

        [TestMethod]
        public void When_get_credential_invalid()
        {
            var mock = new Mock<IProfileGateway>();
            mock.Setup(m => m.GetCredential(It.Is<string>(x => x == "nicolas.dfr@gmail.com")))
                .Returns(GetDynCredential(1, "1000:KWU+t5BwnXW/ICyx2isYpC/mMhjfr2rU:Nx+EFln7syhIHNYF0kRRFmoVLxjQWOpS"));

            var profileRepository = new ProfileRepository(mock.Object);
            var actual = profileRepository.GetCredential("nicolas.dfr@gmail.com", "invalid");

            Assert.IsNull(actual);
        }

        [TestMethod]
        public void When_get_credential_notfound()
        {
            var mock = new Mock<IProfileGateway>();
            mock.Setup(m => m.GetCredential(It.Is<string>(x => x == "nicolas.dfr@gmail.com")))
                .Returns(GetDynCredential(1, "password"));

            var profileRepository = new ProfileRepository(mock.Object);
            var actual = profileRepository.GetCredential("notfound@gmail.com", "password");

            Assert.IsNull(actual);
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

        private object GetDynInstagram(dynamic d, string accessToken, long userId, string profilePicture)
        {
            d.AccessToken = accessToken;
            d.InstagramUserId = userId;
            d.ProfilePicture = profilePicture;

            return d;
        }

        private object GetDynGodfather(dynamic d, string nickname, int gender, string city)
        {
            d.GodfatherNickname = nickname;
            d.GodfatherGender = gender;
            d.GodfatherCity = city;

            return d;
        }

        private object GetDynCredential(int id, string password)
        {
            dynamic d = new ExpandoObject();
            d.Id = id;
            d.Password = password;
            return d;
        }
    }
}
