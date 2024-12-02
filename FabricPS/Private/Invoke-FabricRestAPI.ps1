function Invoke-FabricRestAPI {
    <#
    .SYNOPSIS
    Creates a new notebook in a specified Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and creates a new notebook in the specified workspace.

    .PARAMETER Endpoint
    The Fabric API endpoint to call. Don't include the inital slash.

    .PARAMETER RequstPayload
    The request payload to send to the Fabric API.

    .PARAMETER RestVerb
    The HTTP verb to use for the request.

    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$Endpoint,

        [Parameter(Mandatory = $true)]
        [ValidateSet("GET", "POST", "DELETE")]
        [string]$Verb,
        
        [Parameter(Mandatory = $false)]
        [string]$Payload
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
        try {
            # Retrieve the access token for the Fabric API
            $tokenResponse = Get-AzAccessToken -ResourceUrl "https://api.fabric.microsoft.com"
    
            if (-not $tokenResponse) {
                throw "Unable to retrieve access token."
            }
    
            $accessToken = $tokenResponse.Token
        }
        catch {
            Write-Error "Failed to retrieve access token: $_"
        }

        $uri = "https://api.fabric.microsoft.com/v1/$Endpoint"
        $headers = @{
            Authorization  = "Bearer $accessToken"
            Accept         = "application/json"
            "Content-Type" = "application/json"
        }

        if ($Payload -eq $null) {
            $hasPayload = $true
        } else {
            $hasPayload = $false
        }

        # Construct the request body
        if ($hasPayload) {
            $bodyJson = $Payload | ConvertTo-Json -Depth 10
            $response = Invoke-WebRequest -Uri $uri -Headers $headers -Method $Verb -Body $bodyJson -UseBasicParsing -ErrorAction Stop
        }
        else {
            $response = Invoke-WebRequest -Uri $uri -Headers $headers -Method $Verb -UseBasicParsing -ErrorAction Stop
        }

        # Send the POST request to create the notebook
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
                    Write-Error "New notebook operation failed."
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
                    Write-Error "New notebook operation timed out."
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
        Write-Error "Failed to call ${Endpoint}: $_"
    }
}