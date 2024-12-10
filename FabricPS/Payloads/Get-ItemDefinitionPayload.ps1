function Get-ItemDefinitionPayload {
    param (
        [Parameter(Mandatory = $true)]
        [string]$DirectoryPath
    )

    $parts = @()

    $files = Get-ChildItem -Path $DirectoryPath -File -Force
    # Loop through each file in the directory
    $files | ForEach-Object {
        $fileContent = Get-Content -Path $_.FullName -Raw
        $base64Content = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($fileContent))

        $part = @{
            path = $_.Name
            payload = $base64Content
            payloadType = "InlineBase64"
        }

        $parts += $part
    }

    $definition = @{
        parts = $parts
    }

    return $payload
}