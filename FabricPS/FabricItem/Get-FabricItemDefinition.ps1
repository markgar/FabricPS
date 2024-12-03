function Get-FabricItemDefinition {
    <#
    .SYNOPSIS
    Retrieves the definition of the specified Fabric item.

    .DESCRIPTION
    Connects to the Fabric API and retrieves the definition of the specified item in the given workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the item.

    .PARAMETER ItemId
    The unique identifier of the item whose definition is to be retrieved.

    .EXAMPLE
    Get-FabricItemDefinition -WorkspaceId "00000000-0000-0000-0000-000000000000" -ItemId "00000000-0000-0000-0000-000000000000"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$ItemId
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/items/$ItemId/getDefinition" -Verb POST
    return $response
}

