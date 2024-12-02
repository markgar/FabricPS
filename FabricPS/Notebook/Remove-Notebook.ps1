function Remove-Notebook {
    <#
    .SYNOPSIS
    Retrieves the definition of a specified Fabric notebook.

    .DESCRIPTION
    Deletes the specified Fabric notebook using a DELETE request.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the notebook.

    .PARAMETER NotebookId
    The unique identifier of the notebook whose definition is to be retrieved.

    .EXAMPLE
    Delete-Notebook -WorkspaceId "your-workspace-id" -NotebookId "your-notebook-id"

    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$NotebookId
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/notebooks/$NotebookId" -Verb "DELETE"
    return $response
}