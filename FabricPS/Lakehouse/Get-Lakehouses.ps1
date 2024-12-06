function Get-Lakehouses {
    <#
    .SYNOPSIS
    Retrieves all lakehouses from a specified Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and retrieves all lakehouses in the given workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the lakehouses.

    .EXAMPLE
    Get-Lakehouses -WorkspaceId "00000000-0000-0000-0000-000000000000"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/lakehouses" -Verb "GET"
    return $response
}