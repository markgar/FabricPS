function Get-LakehouseTables {
    <#
    .SYNOPSIS
    Retrieves tables from a specified lakehouse in a Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and retrieves tables from the specified lakehouse in the given workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the lakehouse.

    .PARAMETER LakehouseId
    The unique identifier of the lakehouse containing the tables.

    .EXAMPLE
    Get-LakehouseTables -WorkspaceId "00000000-0000-0000-0000-000000000000" `
                        -LakehouseId "00000000-0000-0000-0000-000000000000"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$LakehouseId
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/lakehouses/$LakehouseId/tables" -Verb "GET"
    return $response
}