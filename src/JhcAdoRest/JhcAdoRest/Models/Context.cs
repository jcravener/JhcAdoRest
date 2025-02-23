using System;
using System.Collections.Generic;
using System.Linq;
using System.Security;
using System.Text;
using System.Threading.Tasks;

namespace JhcAdoRest.Models
{
    public class Context
    {
        public string? Organization { get; set; }

        public string? Project { get; set; }

        public SecureString? Pat { get; set; }
    }
}
