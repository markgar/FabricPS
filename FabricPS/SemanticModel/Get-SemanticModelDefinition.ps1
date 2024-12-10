function Get-SemanticModelDefinition {
    <#
    .SYNOPSIS
    Retrieves the definition of the specified semantic model.

    .DESCRIPTION
    Connects to the Fabric API and retrieves the definition of the specified semantic model in the given workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the semantic model.

    .PARAMETER SemanticModelId
    The unique identifier of the semantic model whose definition is to be retrieved.

    .EXAMPLE
    Get-SemanticModelDefinition -WorkspaceId "00000000-0000-0000-0000-000000000000" -SemanticModelId "00000000-0000-0000-0000-000000000000"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$SemanticModelId
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/semanticModels/$SemanticModelId/getDefinition" -Verb POST
    return $response
}