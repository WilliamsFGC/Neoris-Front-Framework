namespace Web.Model
{
    public class BookModel
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public int Year { get; set; }
        public string Genre { get; set; }
        public int Pages { get; set; }
        public int AuthorId { get; set; }
    }
}