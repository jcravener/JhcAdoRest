using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace JhcAdoRest.Client
{
    public class ApiClient : IApiClient, IDisposable
    {
        private readonly HttpClient _httpClient;
        private bool _disposed;

        public ApiClient(HttpClient httpClient, string personalAccessToken)
        {
            _httpClient = httpClient;

            if (!string.IsNullOrWhiteSpace(personalAccessToken))
            {
                _httpClient.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue("Bearer", personalAccessToken);
            }
            else
            {
                throw new ArgumentException("PAT was null or empty", nameof(personalAccessToken));
            }
        }

        public async Task<string> GetAsync(string endpoint)
        {
            try
            {
                var response = await _httpClient.GetAsync(endpoint);
                response.EnsureSuccessStatusCode();
                return await response.Content.ReadAsStringAsync();
            }
            catch (HttpRequestException ex)
            {
                throw new Exception($"Http reguest error making GET request to {endpoint}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error making GET request to {endpoint}", ex);
            }
        }

        public async Task<string> PostAsync(string endpoint, object payload)
        {
            var content = new StringContent(
                JsonConvert.SerializeObject(payload),
                Encoding.UTF8,
                "application/json");

            var response = await _httpClient.PostAsync(endpoint, content);
            response.EnsureSuccessStatusCode();
            return await response.Content.ReadAsStringAsync();
        }

        public async Task<string> PutAsync(string enpoint, object payload)
        {
            var content = new StringContent(
                JsonConvert.SerializeObject(payload),
                Encoding.UTF8,
                "application/json");

            var response = await _httpClient.PutAsync(enpoint, content);
            response.EnsureSuccessStatusCode();
            return await response.Content.ReadAsStringAsync();
        }

        public async Task DeleteAsync(string endpoint)
        {
            var response = await _httpClient.DeleteAsync(endpoint);
            response.EnsureSuccessStatusCode();
        }

        public void Dispose()
        {
            Dispose(disposing: true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (_disposed) return;

            if (disposing)
            {
                _httpClient.Dispose();
            }

            _disposed = true;
        }
    }
}
