function New-Notebook {
    <#
    .SYNOPSIS
    Creates a new notebook in a specified Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and creates a new notebook in the specified workspace.

    .PARAMETER WorkspaceId
    The ID of the workspace where the notebook will be created.

    .PARAMETER DisplayName
    The name of the notebook to create.

    .PARAMETER Description
    (Optional) A description for the notebook. Cannot exceed 4000 characters.

    .EXAMPLE
    New-Notebook -WorkspaceId "00000000-0000-0000-0000-000000000000" `
                 -DisplayName "Notebook 1" `
                 -Description "A notebook description"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$DisplayName,

        [Parameter(Mandatory = $false)]
        [string]$Description
    )

    # Construct the request body
    $body = @{
        displayName = $DisplayName
    }

    if ($Description) {
        $body.description = $Description
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/notebooks" -Verb "POST" -Payload $bodyJson
    return $response
}