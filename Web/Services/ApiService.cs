using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Web.Model;

namespace Web.Services
{
    public class ApiService<T, R>
    {
        public enum RequestType
        {
            POST, PUT, DELETE, GET
        }

        private string baseUrl = "https://localhost:7078/";

        public async Task<GenericResponse<R>> CallService(string url, RequestType requestType, T body)
        {
            HttpClient client = new HttpClient();
            client.BaseAddress = new Uri(baseUrl);

            HttpResponseMessage response = null;
            switch (requestType)
            {
                case RequestType.POST:
                    HttpContent content = new StringContent(JsonConvert.SerializeObject(body), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(url, content);
                    break;
                case RequestType.PUT:
                    HttpContent contentPut = new StringContent(JsonConvert.SerializeObject(body), Encoding.UTF8, "application/json");
                    response = await client.PutAsync(url, contentPut);
                    break;
                case RequestType.DELETE:
                    response = await client.DeleteAsync(url);
                    break;
                default:
                    response = await client.GetAsync(url);
                    break;
            }

            response.EnsureSuccessStatusCode();

            string responseBody = await response.Content.ReadAsStringAsync();
            return JsonConvert.DeserializeObject<GenericResponse<R>>(responseBody);
        }
    }
}