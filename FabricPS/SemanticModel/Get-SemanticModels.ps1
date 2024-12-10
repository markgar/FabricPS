function Get-SemanticModels {
    <#
    .SYNOPSIS
    Retrieves all semantic models from a specified Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and retrieves all semantic models in the given workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the semantic models.

    .EXAMPLE
    Get-SemanticModels -WorkspaceId "00000000-0000-0000-0000-000000000000"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    $endpoint = "workspaces/$WorkspaceId/semanticModels"

    $response = Invoke-FabricRestAPI -Endpoint $endpoint -Verb "GET"
    return $response
}