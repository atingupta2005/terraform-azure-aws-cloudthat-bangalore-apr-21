# Configure the Microsoft Azure Provider.
provider "azurerm" {
    
}

# Define Azure Policy Definition
resource "azurerm_policy_definition" "policy" {
  name         = "PaC-Naming-Convention"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "PaC_Naming_Convention"

  metadata     = <<METADATA
    {
    "category": "Demo"
    }
  METADATA

  policy_rule = <<POLICY_RULE
    {
    "if": {
		"allOf":[
			{
				"not":{
					"field":"name",
					"match":"[parameters('namePattern')]"
				}
			},
			{
				"field": "type",
				"equals": "Microsoft.Compute/virtualMachines"
			}
		]
    },
    "then": {
      "effect": "deny"
    }
  }
POLICY_RULE

  parameters = <<PARAMETERS
    {
		"namePattern":{
			"type": "String",
			"metadata":{
				"displayName": "namePattern",
				"description": "? for letter, # for numbers"
			}
		}
  }
PARAMETERS
}

# Define Azure Policy Assignment
resource "azurerm_policy_assignment" "policy-assignment" {
  name                 = "Naming-Convention-Assignment"
  scope                = "/subscriptions/00000000-0000-0000-0000-000000000000"
  policy_definition_id = "${azurerm_policy_definition.policy.id}"
  description          = "Naming convention for VM"
  display_name         = "Naming-Convention-Assignment"

  parameters = <<PARAMETERS
{
  "namePattern": {
    "value": "demo-???-####"
  }
}
PARAMETERS
}
