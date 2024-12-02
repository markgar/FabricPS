function Get-ItemDefinition {
    <#
    .SYNOPSIS
    Retrieves the definition of a specified Fabric notebook.

    .DESCRIPTION
    Connects to the Fabric API and retrieves the definition of the notebook identified by the provided WorkspaceId and NotebookId using a POST request.
    If the API responds with a 202 status code and includes the 'x-ms-operation-id' header, the function makes an additional GET request
    to retrieve the actual result of the asynchronous operation.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the notebook.

    .PARAMETER NotebookId
    The unique identifier of the notebook whose definition is to be retrieved.

    .EXAMPLE
    Get-NotebookDefinition -WorkspaceId "your-workspace-id" -NotebookId "your-notebook-id"

    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$ItemId
    )

    $response = Invoke-FabricRestAPI -Endpoint "workspaces/$WorkspaceId/items/$ItemId/getDefinition" -Verb POST
    return $response
}

