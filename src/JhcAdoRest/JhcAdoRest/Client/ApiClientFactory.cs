using JhcAdoRest.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;

namespace JhcAdoRest.Client
{
    public class ApiClientFactory
    {
        private readonly PSCmdlet _cmdlet;

        public ApiClientFactory(PSCmdlet cmdlet)
        {
            _cmdlet = cmdlet ?? throw new ArgumentNullException(nameof(cmdlet));
        }

        public ApiClient CreateClient()
        {
            var context = _cmdlet.SessionState.PSVariable.Get(Constants.ContextVariableName)?.Value as Context;

            if (context == null)
            {
                throw new InvalidOperationException("RestEnvironment is not set. Use Set-RestEnvironment to configure it.");
            }

            var pat = new System.Net.NetworkCredential(string.Empty, context.Pat).Password;

            var httpClient = new HttpClient
            {
                BaseAddress = new Uri($"{Constants.BaseUrl}/{context.Organization}/{context.Project}/")
            };

            return new ApiClient(httpClient, pat);
        }
    }
}
