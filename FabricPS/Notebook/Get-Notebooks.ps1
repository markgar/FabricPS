function Get-Notebooks {
    <#
    .SYNOPSIS
    Retrieves all notebooks from a specified Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and retrieves all notebooks in the given workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the notebooks.

    .EXAMPLE
    Get-Notebooks -WorkspaceId "00000000-0000-0000-0000-000000000000"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/notebooks" -Verb "GET"
    return $response
}

