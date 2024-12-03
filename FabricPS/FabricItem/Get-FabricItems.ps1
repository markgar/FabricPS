function Get-FabricItems {
    <#
    .SYNOPSIS
    Retrieves items of a specified type from a Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and retrieves items of the specified type in the given workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the items.

    .PARAMETER Type
    The type of items to retrieve. Currently, only "Notebook" is supported.

    .EXAMPLE
    Get-FabricItems -WorkspaceId "00000000-0000-0000-0000-000000000000" -Type "Notebook"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Notebook")]
        [string]$Type
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/items?type=$Type" -Verb "GET"
    return $response
}

