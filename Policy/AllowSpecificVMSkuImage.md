# Allow Specific Virtual Machine SKU Image
This Policy has been created to only allow the following Microsoft Server images for a particular resource group <\br>
- 2019-Datacenter 
- 2016-Datacenter

This could be extended to add a specific version or template if required.

```
{
  "mode": "All",
  "policyRule": {
    "if": {
      "allOf": [
        {
          "field": "type",
          "in": [
            "Microsoft.Compute/disks",
            "Microsoft.Compute/virtualMachines",
            "Microsoft.Compute/VirtualMachineScaleSets"
          ]
        },
        {
          "not": {
            "allOf": [
              {
                "field": "Microsoft.Compute/imagePublisher",
                "in": [
                  "MicrosoftWindowsServer"
                ]
              },
              {
                "field": "Microsoft.Compute/imageOffer",
                "in": [
                  "WindowsServer"
                ]
              },
              {
                "field": "Microsoft.Compute/imageSku",
                "in": [
                  "2019-Datacenter",
                  "2016-Datacenter"
                ]
              }
            ]
          }
        }
      ]
    },
    "then": {
      "effect": "deny"
    }
  },
  "parameters": {}
}
```
