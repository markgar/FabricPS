function New-WorkspaceRoleAssignment {
    <#
    .SYNOPSIS
    Creates a new workspace in a specified Fabric capacity.

    .DESCRIPTION
    Connects to the Fabric API and creates a new workspace in the specified capacity.

    .PARAMETER DisplayName
    The name of the workspace to create.

    .PARAMETER CapacityId
    (Optional) The ID of the capacity where the workspace will be created.

    .PARAMETER Description
    (Optional) A description for the workspace. Cannot exceed 4000 characters.

    .EXAMPLE
    New-Workspace -DisplayName "Workspace 1" `
                  -CapacityId "00000000-0000-0000-0000-000000000000" `
                  -Description "A workspace description" `

    .EXAMPLE
    New-Workspace -DisplayName "DevWorkspace" `
                  -Verbose
    #>
    param (
        [Parameter(Mandatory = $false)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$PrincipalId,
    
        [Parameter(Mandatory = $true)]
        [ValidateSet("User", "ServicePrincipal")] # todo: add support for Group, ServicePrincipalProfile
        [string]$PrincipalType,
        
        [Parameter(Mandatory = $true)]
        [ValidateSet("Admin", "Contributor", "Member", "Viewer")]
        [string]$WorkspaceRole
    )

    # Construct the request body
    $body = @{
        principal = @{
            id = $PrincipalId
            type = $PrincipalType
        }
        role = $WorkspaceRole
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/roleAssignments" -Verb "POST" -Payload $bodyJson
    return $response
}