function New-SemanticModel {
    <#
    .SYNOPSIS
    Creates a new semantic model in a specified Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and creates a new semantic model in the specified workspace.

    .PARAMETER WorkspaceId
    The ID of the workspace where the semantic model will be created.

    .PARAMETER DisplayName
    The name of the semantic model to create.

    .PARAMETER Description
    (Optional) A description for the semantic model.

    .PARAMETER Definition
    The definition for the semantic model.

    .EXAMPLE
    New-SemanticModel -WorkspaceId "00000000-0000-0000-0000-000000000000" `
                      -DisplayName "SemanticModel 1" `
                      -Description "A semantic model description." `
                      -Definition $definition
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 256)]
        [string]$DisplayName,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $true)]
        [string]$Definition
    )

    # Construct the request body
    $body = @{
        displayName = $DisplayName
        description = $Description
        definition = $Definition
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/semanticModels" -Verb "POST" -Payload $bodyJson
    return $response
}