function Update-FabricItem {
    <#
    .SYNOPSIS
    Updates an existing item in a specified Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and updates an existing item in the specified workspace.

    .PARAMETER WorkspaceId
    The ID of the workspace containing the item to be updated.

    .PARAMETER ItemId
    The unique identifier of the item to be updated.

    .PARAMETER DisplayName
    The new name of the item.

    .PARAMETER Description
    (Optional) A new description for the item. Cannot exceed 4000 characters.

    .EXAMPLE
    Update-FabricItem -WorkspaceId "00000000-0000-0000-0000-000000000000" `
                      -ItemId "00000000-0000-0000-0000-000000000000" `
                      -DisplayName "Updated Item Name" `
                      -Description "An updated description"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$ItemId,

        [Parameter(Mandatory = $true)]
        [string]$DisplayName,

        [Parameter(Mandatory = $false)]
        [string]$Description
    )

    # Construct the request body
    $body = @{
        displayName = $DisplayName
    }

    # documentation says it is not optional, but i think it is
    if ($Description) {
        $body.description = $Description
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/items/$ItemId" -Verb "PATCH" -Payload $bodyJson
    return $response
}