function Remove-NotebookOld {
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

    $uri = "https://api.fabric.microsoft.com/v1/workspaces/$WorkspaceId/notebooks/$NotebookId"
    $headers = @{
        Authorization  = "Bearer $accessToken"
        Accept         = "application/json"
        "Content-Type" = "application/json"
    }

    try {
        # Send the POST request to retrieve the notebook definition
        $response = Invoke-WebRequest -Uri $uri -Headers $headers -Method Delete -UseBasicParsing -ErrorAction Stop

        $statusCode = $response.StatusCode

        if ($statusCode -eq 200) {
            $responseObj = $response.Content | ConvertFrom-Json
            return $responseObj
        }
        elseif (($statusCode -eq 202) -and ($response.Headers["x-ms-operation-id"])) {
            # Check for 'x-ms-operation-id' header
            $operationId = $response.Headers["x-ms-operation-id"]

            # Construct the operation state URI
            $operationStatetUri = "https://api.fabric.microsoft.com/v1/operations/$operationId"

            $operationStatus = ""
            $seconds = 1
            while ($operationStatus -ne "Succeeded") {
                # Give just a little time to process
                Start-Sleep -Milliseconds 100
                # Send GET request to retrieve the operation state
                $operationStateResponse = Invoke-RestMethod -Uri $operationStatetUri -Headers $headers -Method Get -ErrorAction Stop

                $operationStatus = $operationStateResponse.status

                # Check for failure
                if ($operationStatus -eq "Failed") {
                    Write-Error "Notebook definition operation failed."
                    return
                }
                
                # Only sleep if the operation is still in progress
                if ($operationStatus -ne "Succeeded")
                {
                    Start-Sleep -Seconds $seconds
                }
        
                # Exponential backoff
                $seconds = $seconds * 2
                if ($seconds -gt 16)
                {
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
        Write-Error "Failed to retrieve notebook definition: $_"
        return
    }
}

