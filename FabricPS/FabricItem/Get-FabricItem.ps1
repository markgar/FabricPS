function Get-FabricItem {
    <#
    .SYNOPSIS
    Retrieves the specified Fabric item using a GET request.

    .DESCRIPTION
    Connects to the Fabric API and retrieves the specified item in the given workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the item.

    .PARAMETER ItemId
    The unique identifier of the item to retrieve.

    .EXAMPLE
    Get-FabricItem -WorkspaceId "00000000-0000-0000-0000-000000000000" -ItemId "00000000-0000-0000-0000-000000000000"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$ItemId
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/items/$ItemId" -Verb "GET"
    return $response
}
