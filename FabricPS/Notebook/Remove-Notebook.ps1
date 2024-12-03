function Remove-Notebook {
    <#
    .SYNOPSIS
    Deletes a specified Fabric notebook.

    .DESCRIPTION
    Deletes the specified Fabric notebook using a DELETE request.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the notebook.

    .PARAMETER NotebookId
    The unique identifier of the notebook to be deleted.

    .EXAMPLE
    Remove-Notebook -WorkspaceId "00000000-0000-0000-0000-000000000000" -NotebookId "00000000-0000-0000-0000-000000000000"
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