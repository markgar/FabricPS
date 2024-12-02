function Get-Items {
    <#
    .SYNOPSIS
    Retrieves the definition of a specified Fabric notebook.

    .DESCRIPTION
    Deletes the specified Fabric notebook using a DELETE request.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the notebook.

    .EXAMPLE
    Get-Notebooks -workspaceId "your-workspace-id"

    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,


        [Parameter(Mandatory = $true)]
        [ValidateSet("Notebook")]
        [string]$ItemType
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/items?type=$ItemType" -Verb "GET"
    return $response
}

