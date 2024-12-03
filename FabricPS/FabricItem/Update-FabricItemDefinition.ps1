function Update-FabricItemDefinition {
    <#
    .SYNOPSIS
    Updates the definition of a specified Fabric item.

    .DESCRIPTION
    Connects to the Fabric API and updates the definition of the item identified by the provided WorkspaceId and ItemId using a POST request.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the item.

    .PARAMETER ItemId
    The unique identifier of the item whose definition is to be updated.

    .PARAMETER Definition
    The new definition for the item.

    .EXAMPLE
    $newDefinition = @{
        {{Each different item has a different definition structure}}
    }

    Update-FabricItemDefinition -WorkspaceId "00000000-0000-0000-0000-000000000000" `
                                -ItemId "00000000-0000-0000-0000-000000000000" `
                                -Definition $newDefinition
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$ItemId,

        [Parameter(Mandatory = $true)]
        [string]$Definition
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/items/$ItemId/updateDefinition" -Verb "POST" -Payload $Definition
    return $response
}