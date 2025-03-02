using JhcAdoRest.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Security;
using System.Text;
using System.Threading.Tasks;

namespace JhcAdoRest.cmdlets
{
    [Cmdlet(VerbsCommon.Set, "RestEnvironment")]
    public class RestEnvironment : PSCmdlet
    {
        [Parameter( Position = 0,Mandatory = true)]
        public string? Organization { get; set; }

        [Parameter(Position = 2, Mandatory = true)]
        public string? Project { get; set; }

        [Parameter(Position = 3, Mandatory = true)]
        public SecureString? Pat { get; set; }

        protected override void ProcessRecord() 
        {
            Context context = new Context
            {
                Organization = Organization,
                Project = Project,
                Pat = Pat
            };

            SessionState.PSVariable.Set(Constants.ContextVariableName, context);
        }
    }
}
