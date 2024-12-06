function Remove-Lakehouse {
    <#
    .SYNOPSIS
    Deletes a specified lakehouse from a Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and deletes the specified lakehouse in the given workspace using a DELETE request.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the lakehouse.

    .PARAMETER LakehouseId
    The unique identifier of the lakehouse to be deleted.

    .EXAMPLE
    Remove-Lakehouse -WorkspaceId "00000000-0000-0000-0000-000000000000" -LakehouseId "00000000-0000-0000-0000-000000000000"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$LakehouseId
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/lakehouses/$LakehouseId" -Verb "DELETE"
    return $response
}