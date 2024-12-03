function Update-NotebookDefinition {
    <#
    .SYNOPSIS
    Updates the definition of a specified Fabric notebook.

    .DESCRIPTION
    Connects to the Fabric API and updates the definition of the specified notebook in the given workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the notebook.

    .PARAMETER NotebookId
    The unique identifier of the notebook whose definition is to be updated.

    .PARAMETER Definition
    The new definition for the notebook.

    .EXAMPLE
    $newDefinition = $object = @{
        definition = @{
            parts = @(
                @{
                    path = "notebook-content.py"
                    payload = "IyBGYWJyaWMgbm90ZWJv..."
                    payloadType = "InlineBase64"
                },
                @{
                    path = ".platform"
                    payload = "ZG90UGxhdGZvcm1CYXNlNjRTdHJpb..."
                    payloadType = "InlineBase64"
                }
            )
        }
    }

    Update-NotebookDefinition -WorkspaceId "00000000-0000-0000-0000-000000000000" `
                              -NotebookId "00000000-0000-0000-0000-000000000000" `
                              -Definition $newDefinition
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$NotebookId,

        [Parameter(Mandatory = $true)]
        [string]$Definition
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/notebooks/$NotebookId/updateDefinition" -Verb "POST" -Payload $Definition
    return $response
}