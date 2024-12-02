function Update-NotebookDefinition {
    <#
    .SYNOPSIS
    Updates the definition of a specified Fabric notebook.

    .DESCRIPTION
    Connects to the Fabric API and updates the definition of the notebook identified by the provided WorkspaceId and NotebookId using a POST request.
    If the API responds with a 202 status code and includes the 'x-ms-operation-id' header, the function makes an additional GET request
    to retrieve the actual result of the asynchronous operation.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the notebook.

    .PARAMETER NotebookId
    The unique identifier of the notebook whose definition is to be updated.

    .PARAMETER Definition
    The new definition for the notebook.

    .EXAMPLE
    $newDefinition = @{
        displayName = "Updated Notebook Name"
        description = "Updated description for the notebook."
        # Add other necessary definition properties here
    }

    Update-NotebookDefinition -WorkspaceId "your-workspace-id" `
                              -NotebookId "your-notebook-id" `
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