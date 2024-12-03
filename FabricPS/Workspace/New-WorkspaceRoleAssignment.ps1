function New-WorkspaceRoleAssignment {
    <#
    .SYNOPSIS
    Assigns a role to a principal in a specified Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and assigns a role to a principal (user or service principal) in the specified workspace.

    .PARAMETER WorkspaceId
    (Optional) The ID of the workspace where the role assignment will be created.

    .PARAMETER PrincipalId
    The ID of the principal (user or service principal) to assign the role to.

    .PARAMETER PrincipalType
    The type of the principal. Valid values are "User" and "ServicePrincipal".

    .PARAMETER WorkspaceRole
    The role to assign to the principal. Valid values are "Admin", "Contributor", "Member", and "Viewer".

    .EXAMPLE
    New-WorkspaceRoleAssignment -WorkspaceId "00000000-0000-0000-0000-000000000000" `
                                -PrincipalId "00000000-0000-0000-0000-000000000000" `
                                -PrincipalType "User" `
                                -WorkspaceRole "Contributor"
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