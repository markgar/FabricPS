function Get-SemanticModel {
    <#
    .SYNOPSIS
    Retrieves a semantic model from a specified Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and retrieves the specified semantic model in the given workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the semantic model.

    .PARAMETER SemanticModelId
    The unique identifier of the semantic model to retrieve.

    .EXAMPLE
    Get-SemanticModel -WorkspaceId "00000000-0000-0000-0000-000000000000" -SemanticModelId "00000000-0000-0000-0000-000000000000"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$SemanticModelId
    )

    $endpoint = "workspaces/$WorkspaceId/semanticModels/$SemanticModelId"

    $response = Invoke-FabricRestAPI -Endpoint $endpoint -Verb "GET"
    return $response
}