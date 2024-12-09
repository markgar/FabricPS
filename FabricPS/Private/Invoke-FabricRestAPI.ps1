function Invoke-FabricRestAPI {
    <#
    .SYNOPSIS
    Invokes a REST API call to the Fabric service.

    .DESCRIPTION
    Connects to the Fabric API and performs a REST API call using the specified endpoint, HTTP verb, and payload.

    .PARAMETER Endpoint
    The Fabric API endpoint to call. Do not include the initial slash.

    .PARAMETER Verb
    The HTTP verb to use for the request. Valid values are "GET", "POST", and "DELETE".

    .PARAMETER Payload
    (Optional) The request payload to send to the Fabric API.

    .EXAMPLE
    Invoke-FabricRestAPI -Endpoint "workspaces/00000000-0000-0000-0000-000000000000/items" -Verb "GET"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$Endpoint,

        [Parameter(Mandatory = $true)]
        [ValidateSet("GET", "POST", "DELETE", "PATCH")]
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

        if ($Payload -ne $null) {
            $hasPayload = $true
        } else {
            $hasPayload = $false
        }

        # Construct the request body
        if ($hasPayload) {
            $response = Invoke-WebRequest -Uri $uri -Headers $headers -Method $Verb -Body $Payload -UseBasicParsing -ErrorAction Stop
        }
        else {
            $response = Invoke-WebRequest -Uri $uri -Headers $headers -Method $Verb -UseBasicParsing -ErrorAction Stop
        }

        # Check for success
        $statusCode = $response.StatusCode

        if (($statusCode -eq 200) -or ($statusCode -eq 201)) {
            $responseObj = $response.Content | ConvertFrom-Json
            return $responseObj
        }
        elseif (($statusCode -eq 202)) {
            # Check for 'x-ms-operation-id' header
            $operationId = $response.Headers["x-ms-operation-id"]
            $retryAfter = [int]$response.Headers["Retry-After"].value
            Start-Sleep -Milliseconds $retryAfter

            # Construct the operation state URI
            $operationStatetUri = "https://api.fabric.microsoft.com/v1/operations/$operationId"

            $operationStatus = ""
            $seconds = 1
            while ($operationStatus -ne "Succeeded") {
                # Send GET request to retrieve the operation state
                $operationStateResponse = Invoke-RestMethod -Uri $operationStatetUri -Headers $headers -Method Get -ErrorAction Stop

                $operationStatus = $operationStateResponse.status

                # Check for failure
                if ($operationStatus -eq "Failed") {
                    Write-Error $operationStateResponse.error
                    return
                }
                
                # Only sleep if the operation is still in progress
                if ($operationStatus -ne "Succeeded")
                {
                    Start-Sleep -Seconds $seconds
                }
        
                # Exponential backoff
                $seconds = $seconds * 2
                if ($seconds -gt 64)
                {
                    Write-Error "Operation timed out."
                    return
                }
            }

            if ($operationStateResponse.status -eq "Succeeded") {
                # Construct the operation result URI
                $operationResultUri = "https://api.fabric.microsoft.com/v1/operations/$operationId/result"
                try {
                    $operationResultResponse = Invoke-WebRequest -Uri $operationResultUri -Headers $headers -Method Get -ErrorAction Stop
                    return $operationResultResponse.Content | ConvertFrom-Json
                }
                catch {
                    if ($_.Exception.Response -and $_.Exception.Response.StatusCode -eq 400) {
                        $errorResponse = $_.Exception.Response.GetResponseStream() | New-Object System.IO.StreamReader | ForEach-Object { $_.ReadToEnd() } | ConvertFrom-Json
                        if ($errorResponse.errorCode -eq "OperationHasNoResult") {
                            Write-Error "The operation has no result."
                        }
                        else {
                            Write-Error $_
                        }
                    }
                    else {
                        Write-Error $_
                    }
                }
            }      
        }
        else {
            Write-Error "Unexpected status code: $statusCode"
            return
        }
    }
    catch {
        Write-Error $_
    }
}