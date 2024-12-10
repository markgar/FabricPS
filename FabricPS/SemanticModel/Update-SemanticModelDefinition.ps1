function Update-SemanticModelDefinition {
    <#
    .SYNOPSIS
    Updates the definition of the specified semantic model.

    .DESCRIPTION
    Connects to the Fabric API and updates the definition of the specified semantic model in the given workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the semantic model.

    .PARAMETER SemanticModelId
    The unique identifier of the semantic model whose definition is to be updated.

    .PARAMETER Definition
    The new definition for the semantic model.

    .EXAMPLE
    Update-SemanticModelDefinition -WorkspaceId "00000000-0000-0000-0000-000000000000" -SemanticModelId "00000000-0000-0000-0000-000000000000" -Definition $newDefinition
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$SemanticModelId,

        [Parameter(Mandatory = $true)]
        [hashtable]$Definition
    )
    
    $json = $Definition | ConvertTo-Json -Depth 10

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/semanticModels/$SemanticModelId" -Verb "POST" -Payload $json
    return $response
}