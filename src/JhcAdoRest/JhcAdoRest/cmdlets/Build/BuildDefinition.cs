using JhcAdoRest.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;

namespace JhcAdoRest.cmdlets.Build
{
    [Cmdlet("Invoke", "BuildDefinition")]
    public class BuildDefinition : PSCmdlet
    {
        private static readonly string ApiVersion = "7.2-preview.7";

        private static readonly string Endpoint = $"_apis/build/definitions?api-version={ApiVersion}";

        [Parameter(Mandatory = false, Position = 1, ValueFromPipeline = true)]
        public int DefinitionId { get; set; }

        protected override void ProcessRecord()
        {
            try
            {
                var factory = new ApiClientFactory(this);
                using var client = factory.CreateClient();

                var result = client.GetAsync(Endpoint).GetAwaiter().GetResult();

                WriteObject(result);
            }
            catch (Exception ex)
            {
                ThrowTerminatingError(new ErrorRecord(ex, "InvokeBuildDefinitionError", ErrorCategory.NotSpecified, null));
            }
        }
    }
}
