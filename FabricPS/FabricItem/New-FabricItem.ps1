function New-FabricItem {
    <#
    .SYNOPSIS
    Creates a new item in a specified Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and creates a new item in the specified workspace.

    .PARAMETER WorkspaceId
    The ID of the workspace where the item will be created.

    .PARAMETER Type
    The type of item to create. Currently, only "Notebook" is supported.

    .PARAMETER DisplayName
    The name of the item to create.

    .PARAMETER Description
    (Optional) A description for the item. Cannot exceed 4000 characters.

    .EXAMPLE
    New-FabricItem -WorkspaceId "00000000-0000-0000-0000-000000000000" `
                   -Type "Notebook" `
                   -DisplayName "Notebook 1" `
                   -Description "A notebook description"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Notebook")]
        [string]$Type,

        [Parameter(Mandatory = $true)]
        [string]$DisplayName,

        [Parameter(Mandatory = $false)]
        [string]$Description
    )

    # Construct the request body
    $body = @{
        displayName = $DisplayName
        type = $Type
    }

    if ($Description) {
        $body.description = $Description
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/items" -Verb "POST" -Payload $bodyJson
    return $response
}