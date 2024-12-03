function Get-WorkspaceRoleAssignments {
    <#
    .SYNOPSIS
    Retrieves role assignments for a specified Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and retrieves the role assignments for the specified workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace whose role assignments are to be retrieved.

    .EXAMPLE
    Get-WorkspaceRoleAssignments -WorkspaceId "00000000-0000-0000-0000-000000000000"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/roleAssignments" -Verb GET
    return $response
}

