using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Management.Automation;

namespace JhcAdoRest.cmdlets
{
    [Cmdlet(VerbsCommon.Get, "Greeting")]
    public class Greeting : Cmdlet
    {
        [Parameter(
            Position = 0,
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        public string Name { get; set; }

        protected override void ProcessRecord()
        {
            WriteObject($"Hello, {Name}!");
        }
    }
}
