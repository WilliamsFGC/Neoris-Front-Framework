namespace Web.Model
{
    public class GenericResponse<T>
    {
        public T Data { get; set; }
        public string Message { get; set; }
        public bool Error { get; set; }
    }
}