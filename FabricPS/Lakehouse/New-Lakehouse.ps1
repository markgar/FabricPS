function New-Lakehouse {
    <#
    .SYNOPSIS
    Creates a new lakehouse in a specified Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and creates a new lakehouse in the specified workspace.

    .PARAMETER WorkspaceId
    The ID of the workspace where the lakehouse will be created.

    .PARAMETER DisplayName
    The name of the lakehouse to create.

    .PARAMETER Description
    (Optional) A description for the lakehouse. Cannot exceed 4000 characters.

    .EXAMPLE
    New-Lakehouse -WorkspaceId "00000000-0000-0000-0000-000000000000" `
                  -DisplayName "Lakehouse 1" `
                  -Description "A lakehouse description"
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

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/lakehouses" -Verb "POST" -Payload $bodyJson
    return $response
}