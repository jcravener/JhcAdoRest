using JhcAdoRest.Client;
using JhcAdoRest.cmdlets.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Text.Json;
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

                string result = client.GetAsync(Endpoint).GetAwaiter().GetResult();

                PSObject psObject = JsonToPSObjectConverter.ConvertJsonToPSObject(result);

                WriteObject(psObject);
            }
            catch (Exception ex)
            {
                ThrowTerminatingError(new ErrorRecord(ex, nameof(BuildDefinition), ErrorCategory.NotSpecified, null));
            }
        }
    }
}
