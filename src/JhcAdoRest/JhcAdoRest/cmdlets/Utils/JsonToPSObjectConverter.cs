using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Text.Json.Nodes;
using System.Threading.Tasks;

namespace JhcAdoRest.cmdlets.Utils
{
    public static  class JsonToPSObjectConverter
    {
        public static PSObject ConvertJsonToPSObject(string jsonString)
        {
            JsonNode? jsonNode = JsonNode.Parse(jsonString);

            if (jsonNode == null)
            {
                return PSObject.AsPSObject(new { Error = "JSON reponse payload was invalid or null." });
            }

            return ConvertJsonNodeToPSObject(jsonNode);
        }

        public static PSObject ConvertJsonNodeToPSObject(JsonNode jsonNode)
        {
            if(jsonNode is JsonObject jsonObject)
            {
                var psObject = new PSObject();
                foreach(var property in jsonObject)
                {
                    psObject.Properties.Add(new PSNoteProperty(property.Key, ConvertJsonNodeToPSObject(property.Value)));
                }
                return psObject;
            }
            else if (jsonNode is JsonArray jsonArray)
            {
                var list = new List<object>();
                foreach(var item in jsonArray)
                {
                    list.Add(ConvertJsonNodeToPSObject(item));
                }
                return PSObject.AsPSObject(list);
            }
            else if(jsonNode is JsonValue jsonValue)
            {
                return PSObject.AsPSObject(jsonValue.GetValue<object>());
            }
            return null;
        }
    }
}
