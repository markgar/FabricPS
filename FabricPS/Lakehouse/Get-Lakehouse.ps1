function Get-Lakehouse {
    <#
    .SYNOPSIS
    Retrieves a specified lakehouse from a Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and retrieves the specified lakehouse in the given workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the lakehouse.

    .PARAMETER LakehouseId
    The unique identifier of the lakehouse to retrieve.

    .EXAMPLE
    Get-Lakehouse -WorkspaceId "00000000-0000-0000-0000-000000000000" -LakehouseId "00000000-0000-0000-0000-000000000000"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$LakehouseId
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/lakehouses/$LakehouseId" -Verb "GET"
    return $response
}