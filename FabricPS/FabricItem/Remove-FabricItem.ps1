function Remove-FabricItem {
    <#
    .SYNOPSIS
    Deletes a specified Fabric item.

    .DESCRIPTION
    Deletes the specified Fabric item using a DELETE request.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the item.

    .PARAMETER ItemId
    The unique identifier of the item to be deleted.

    .EXAMPLE
    Remove-FabricItem -WorkspaceId "00000000-0000-0000-0000-000000000000" -ItemId "00000000-0000-0000-0000-000000000000"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$ItemId
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/items/$ItemId" -Verb "DELETE"
    return $response
}