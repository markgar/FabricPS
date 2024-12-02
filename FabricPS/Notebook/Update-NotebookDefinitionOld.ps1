function Update-NotebookDefinitionOld {
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

    if (-not (Get-Module -Name Az.Accounts)) {
        try {
            Import-Module Az.Accounts -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to import Az.Accounts module: $_"
            throw
        }
    }

    try {
        $tokenResponse = Get-AzAccessToken -ResourceUrl "https://api.fabric.microsoft.com"
    
        if (-not $tokenResponse) {
            throw "Unable to retrieve access token."
        }
    
        $accessToken = $tokenResponse.Token
    }
    catch {
        Write-Error "Failed to retrieve access token: $_"
        return
    }

    $uri = "https://api.fabric.microsoft.com/v1/workspaces/$WorkspaceId/notebooks/$NotebookId/updateDefinition"
    $headers = @{
        Authorization  = "Bearer $accessToken"
        Accept         = "application/json"
        "Content-Type" = "application/json"
    }

    $bodyJson = $Definition 
    try {
        # Send the POST request to update the notebook definition
        $response = Invoke-WebRequest -Uri $uri -Headers $headers -Method Post -Body $bodyJson -UseBasicParsing -ErrorAction Stop

        $statusCode = $response.StatusCode

        if ($statusCode -eq 200) {
            $responseObj = $response.Content | ConvertFrom-Json
            return $responseObj
        }
        elseif (($statusCode -eq 202) -and ($response.Headers["x-ms-operation-id"])) {
            # Check for 'x-ms-operation-id' header
            $operationId = $response.Headers["x-ms-operation-id"]

            # Construct the operation state URI
            $operationStateUri = "https://api.fabric.microsoft.com/v1/operations/$operationId"

            $operationStatus = ""
            $seconds = 1
            while ($operationStatus -ne "Succeeded") {
                # Give just a little time to process
                Start-Sleep -Milliseconds 100
                # Send GET request to retrieve the operation state
                $operationStateResponse = Invoke-RestMethod -Uri $operationStateUri -Headers $headers -Method Get -ErrorAction Stop

                $operationStatus = $operationStateResponse.status

                # Check for failure
                if ($operationStatus -eq "Failed") {
                    Write-Error "Notebook definition operation failed."
                    return
                }
                
                # Only sleep if the operation is still in progress
                if ($operationStatus -ne "Succeeded") {
                    Start-Sleep -Seconds $seconds
                }

                # Exponential backoff
                $seconds = $seconds * 2
                if ($seconds -gt 16) {
                    Write-Error "Notebook definition operation timed out."
                    return
                }
            }

            if ($operationStateResponse.status -eq "Succeeded") {
                # Construct the operation result URI
                $operationResultUri = "https://api.fabric.microsoft.com/v1/operations/$operationId/result"

                # Send GET request to retrieve the operation result
                $operationResultResponse = Invoke-RestMethod -Uri $operationResultUri -Headers $headers -Method Get -ErrorAction Stop

                return $operationResultResponse
            }
        }
        else {
            Write-Error "Unexpected status code: $statusCode"
            return
        }
    }
    catch {
        Write-Error "Failed to update notebook definition: $_"
        return
    }
}