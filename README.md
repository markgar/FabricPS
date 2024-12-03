# FabricPS
FabricPS is a Powershell module that enables easy access to the Fabric API.

https://www.powershellgallery.com/packages?q=fabricps

# Sample Script
Here is a sample script for using a user principal with MFA
```powershell
Import-Module FabricPS -Force
 
Connect-AzAccount | Out-Null

$workspaces = Get-Workspaces
$workspaces

$workspace = New-Workspace -DisplayName "Test Workspace" -Description "A test workspace"
$workspace

$notebook = New-Notebook -WorkspaceId $workspace.id -DisplayName "Test Notebook" -Description "A test notebook"
```

Here is an example script for using a service principal for automated exeuction
```powershell
Clear-Host

# Import the FabricPS module
Import-Module FabricPS -Force
 
# Define Service Principal credentials
$clientId       = "{{your-client-id}}"          # Replace with your SP's Application (Client) ID
$tenantId       = "{{your-tenant-id}}"          # Replace with your Azure Tenant ID
$clientSecret   = "{{your-client-secret}}"      # Replace with your SP's Client Secret
 
# Convert the client secret to a SecureString
$secureClientSecret = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
 
# Create a PSCredential object
$credential = New-Object System.Management.Automation.PSCredential ($clientId, $secureClientSecret)
 
# Connect to Azure using the Service Principal
Connect-AzAccount -ServicePrincipal -Credential $credential -TenantId $tenantId
 
$workspaces = Get-Workspaces
$workspaces
```