function Update-Lakehouse {
    <#
    .SYNOPSIS
    Updates an existing lakehouse in a specified Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and updates an existing lakehouse in the specified workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the lakehouse.

    .PARAMETER LakehouseId
    The unique identifier of the lakehouse to be updated.

    .PARAMETER DisplayName
    The new name of the lakehouse.

    .PARAMETER Description
    (Optional) A new description for the lakehouse. Cannot exceed 4000 characters.

    .EXAMPLE
    Update-Lakehouse -WorkspaceId "00000000-0000-0000-0000-000000000000" `
                     -LakehouseId "00000000-0000-0000-0000-000000000000" `
                     -DisplayName "Updated Lakehouse Name" `
                     -Description "An updated description"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$LakehouseId,

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

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/lakehouses/$LakehouseId" -Verb "PATCH" -Payload $bodyJson
    return $response
}