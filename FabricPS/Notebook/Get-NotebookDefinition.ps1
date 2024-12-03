function Get-NotebookDefinition {
    <#
    .SYNOPSIS
    Retrieves the definition of a specified Fabric notebook.

    .DESCRIPTION
    Connects to the Fabric API and retrieves the definition of the specified notebook in the given workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the notebook.

    .PARAMETER NotebookId
    The unique identifier of the notebook whose definition is to be retrieved.

    .EXAMPLE
    Get-NotebookDefinition -WorkspaceId "00000000-0000-0000-0000-000000000000" -NotebookId "00000000-0000-0000-0000-000000000000"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$NotebookId
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/notebooks/$NotebookId/getDefinition" -Verb POST
    return $response
}

