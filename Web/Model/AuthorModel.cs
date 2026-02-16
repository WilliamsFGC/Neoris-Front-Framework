using System;

namespace Web.Model
{
    public class AuthorModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public DateTime Birthdate { get; set; }
        public string CityOrigin { get; set; }
        public string Email { get; set; }
    }
}