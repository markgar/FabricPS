function New-Workspace {
    <#
    .SYNOPSIS
    Creates a new workspace in a specified Fabric capacity.

    .DESCRIPTION
    Connects to the Fabric API and creates a new workspace in the specified capacity.

    .PARAMETER DisplayName
    The name of the workspace to create.

    .PARAMETER CapacityId
    (Optional) The ID of the capacity where the workspace will be created.

    .PARAMETER Description
    (Optional) A description for the workspace. Cannot exceed 4000 characters.

    .EXAMPLE
    New-Workspace -DisplayName "Workspace 1" `
                  -CapacityId "00000000-0000-0000-0000-000000000000" `
                  -Description "A workspace description"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 256)]
        [ValidatePattern("^[a-zA-Z0-9_-]+$")]
        [string]$DisplayName,
        
        [Parameter(Mandatory = $false)]
        [string]$CapacityId,

        [Parameter(Mandatory = $false)]
        [string]$Description
    )

    # Construct the request body
    $body = @{

        displayName = $DisplayName
    }

    if($CapacityId)
    {
        $body.capacityId = $CapacityId
    }

    if ($Description) {
        $body.description = $Description
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    $response = Invoke-FabricRestAPI -Endpoint "workspaces" -Verb "POST" -Payload $bodyJson
    return $response
}