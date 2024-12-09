function Get-WorkspaceSparkSettings {
    <#
    .SYNOPSIS
    Retrieves the Spark settings for a specified Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and retrieves the Spark settings for the specified workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace.

    .EXAMPLE
    Get-WorkspaceSparkSettings -WorkspaceId "00000000-0000-0000-0000-000000000000"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    $endpoint = "workspaces/$WorkspaceId/spark/settings"

    $response = Invoke-FabricRestAPI -Endpoint $endpoint -Verb "GET"
    return $response
}