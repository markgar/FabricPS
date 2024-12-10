function Get-NotebookDefinitionPayload {
    param (
        [Parameter(Mandatory=$true)]
        [System.IO.DirectoryInfo]$dir
    )

    # Read the contents of the .platform file and convert it to base64
    $platformFileBytes = Get-Content "$($dir.FullName)/.platform" -Raw
    $platformBase64Content = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($platformFileBytes))
    
    # Read the contents of the notebook-content.py file and convert it to base64
    $pyFileBytes = Get-Content "$($dir.FullName)/notebook-content.py" -Raw
    $pyBase64Content = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($pyFileBytes))

    # Create a payload to send to the API
    $payloadObject = @{
        definition = @{
            parts = @(
                @{
                    path = "notebook-content.py"
                    payload = $pyBase64Content
                    payloadType = "InlineBase64"
                },
                @{
                    path = ".platform"
                    payload = $platformBase64Content
                    payloadType = "InlineBase64"
                }
            )
        }
    }

    # Convert the payload object to JSON
    $payload = $payloadObject | ConvertTo-Json -Depth 10

    return $payload
}