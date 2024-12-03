function Remove-Workspace {
    <#
    .SYNOPSIS
    Deletes a specified Fabric workspace.

    .DESCRIPTION
    Deletes the specified Fabric workspace using a DELETE request.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace to be deleted.

    .EXAMPLE
    Remove-Workspace -WorkspaceId "00000000-0000-0000-0000-000000000000"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId" -Verb "DELETE"
    return $response
}