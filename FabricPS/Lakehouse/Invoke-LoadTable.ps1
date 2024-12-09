function Invoke-LoadTable {
    <#
    .SYNOPSIS
    Loads data into a specified table in a lakehouse.

    .DESCRIPTION
    Connects to the Fabric API and loads data into the specified table in the given lakehouse.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace containing the lakehouse.

    .PARAMETER LakehouseId
    The unique identifier of the lakehouse containing the table.

    .PARAMETER TableName
    The name of the table to load data into. Must match the pattern: ^(?=[0-9]*[a-zA-Z_])[a-zA-Z0-9_]{1,256}$

    .PARAMETER PathType
    The type of relativePath, either file or folder.

    .PARAMETER RelativePath
    The relative path of the data file or folder.

    .PARAMETER FileExtension
    (Optional) The file extension of the data file.

    .PARAMETER FormatOptions
    (Optional) The format options for the data file. Valid values are "Csv" and "Parquet".

    .PARAMETER Mode
    (Optional) The load table operation mode, either overwrite or append.

    .PARAMETER Recursive
    (Optional) Indicates whether to search data files recursively or not, when loading a table from a folder.

    .EXAMPLE
    Invoke-LoadTable -WorkspaceId "00000000-0000-0000-0000-000000000000" `
                     -LakehouseId "00000000-0000-0000-0000-000000000000" `
                     -TableName "MyTable" `
                     -PathType "file" `
                     -RelativePath "Files/abc/abc123.csv" `
                     -FormatOptions @{ format = "Csv"; header = $true; delimiter = "," } `
                     -Mode "Overwrite" `
                     -Recursive $false
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$LakehouseId,

        [Parameter(Mandatory = $true)]
        [ValidatePattern("^(?=[0-9]*[a-zA-Z_])[a-zA-Z0-9_]{1,256}$")]
        [string]$TableName,

        [Parameter(Mandatory = $true)]
        [ValidateSet("file", "folder")]
        [string]$PathType,

        [Parameter(Mandatory = $true)]
        [string]$RelativePath,

        [Parameter(Mandatory = $false)]
        [string]$FileExtension,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Csv", "Parquet")]
        [string]$Format,

        [Parameter(Mandatory = $false)]
        [bool]$Header,

        [Parameter(Mandatory = $false)]
        [string]$Delimiter,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Overwrite", "Append")]
        [string]$Mode,

        [Parameter(Mandatory = $false)]
        [bool]$Recursive
    )

    # Construct the request body
    $body = @{
        pathType = $PathType
        relativePath = $RelativePath
    }

    if ($FileExtension) {
        $body.fileExtension = $FileExtension
    }

    if ($Format -eq "Csv") {
        $options = @{
            format = $Format
            header = $Header
            delimiter = $Delimiter
        }
        $body.formatOptions = $options
    }

    if ($Mode) {
        $body.mode = $Mode
    }

    if ($Recursive -ne $null) {
        $body.recursive = $Recursive
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    $endpoint = "workspaces/$WorkspaceId/lakehouses/$LakehouseId/tables/$TableName/load"

    $response = Invoke-FabricRestAPI -Endpoint $endpoint -Verb "POST" -Payload $bodyJson
    return $response
}