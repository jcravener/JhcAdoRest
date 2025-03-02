using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace JhcAdoRest.Client
{
    public interface IApiClient
    {
        Task<string> GetAsync(string endpoint);
        Task<string> PostAsync(string endpoint, object payload);
        Task<string> PutAsync(string endpoint, object payload);
        Task DeleteAsync(string endpoint);
    }
}
