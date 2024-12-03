function Get-Workspaces {
    <#
    .SYNOPSIS
    Retrieves all Fabric workspaces.

    .DESCRIPTION
    Connects to the Fabric API and retrieves all workspaces.

    .EXAMPLE
    Get-Workspaces
    #>
    param (
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces" -Verb "GET"
    return $response
}

