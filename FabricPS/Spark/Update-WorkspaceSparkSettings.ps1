function Update-WorkspaceSparkSettings {
    <#
    .SYNOPSIS
    Updates the Spark settings for a specified Fabric workspace.

    .DESCRIPTION
    Connects to the Fabric API and updates the Spark settings for the specified workspace.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace.

    .PARAMETER AutomaticLogEnabled
    Indicates whether automatic logging is enabled.

    .PARAMETER NotebookInteractiveRunEnabled
    Indicates whether notebook interactive run is enabled for high concurrency.

    .PARAMETER CustomizeComputeEnabled
    Indicates whether customizing compute is enabled for the pool.

    .PARAMETER DefaultPoolName
    The name of the default pool.

    .PARAMETER DefaultPoolType
    The type of the default pool.

    .PARAMETER StarterPoolMaxNodeCount
    The maximum node count for the starter pool.

    .PARAMETER StarterPoolMaxExecutors
    The maximum number of executors for the starter pool.

    .PARAMETER EnvironmentName
    The name of the environment.

    .PARAMETER RuntimeVersion
    The runtime version of the environment.

    .EXAMPLE
    Update-WorkspaceSparkSettings -WorkspaceId "00000000-0000-0000-0000-000000000000" `
                                  -AutomaticLogEnabled $false `
                                  -NotebookInteractiveRunEnabled $false `
                                  -CustomizeComputeEnabled $false `
                                  -DefaultPoolName "Starter Pool" `
                                  -DefaultPoolType "Workspace" `
                                  -StarterPoolMaxNodeCount 3 `
                                  -StarterPoolMaxExecutors 1 `
                                  -EnvironmentName "environment1" `
                                  -RuntimeVersion "1.2"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [bool]$AutomaticLogEnabled,

        [Parameter(Mandatory = $false)]
        [bool]$NotebookInteractiveRunEnabled,

        [Parameter(Mandatory = $false)]
        [bool]$CustomizeComputeEnabled,

        [Parameter(Mandatory = $false)]
        [string]$DefaultPoolName,

        [Parameter(Mandatory = $false)]
        [string]$DefaultPoolType,

        [Parameter(Mandatory = $false)]
        [int]$StarterPoolMaxNodeCount,

        [Parameter(Mandatory = $false)]
        [int]$StarterPoolMaxExecutors,

        [Parameter(Mandatory = $false)]
        [string]$EnvironmentName,

        [Parameter(Mandatory = $false)]
        [string]$RuntimeVersion
    )

    # Validate pool parameters
    $poolParamsProvided = @(
        $PSBoundParameters.ContainsKey('CustomizeComputeEnabled'),
        $PSBoundParameters.ContainsKey('DefaultPoolName'),
        $PSBoundParameters.ContainsKey('DefaultPoolType')
    )

    if ($poolParamsProvided -contains $false -and $poolParamsProvided -contains $true) {
        throw "All pool parameters must be provided if any are specified."
    }

    # Validate starter pool parameters
    $starterPoolParamsProvided = @(
        $PSBoundParameters.ContainsKey('StarterPoolMaxNodeCount'),
        $PSBoundParameters.ContainsKey('StarterPoolMaxExecutors')
    )

    if ($starterPoolParamsProvided -contains $false -and $starterPoolParamsProvided -contains $true) {
        throw "Both StarterPoolMaxNodeCount and StarterPoolMaxExecutors must be provided if any are specified."
    }

    # Construct the request body
    $body = @{}

    if ($PSBoundParameters.ContainsKey('AutomaticLogEnabled')) {
        $body.automaticLog = @{
            enabled = $AutomaticLogEnabled
        }
    }

    if ($PSBoundParameters.ContainsKey('NotebookInteractiveRunEnabled')) {
        $body.highConcurrency = @{
            notebookInteractiveRunEnabled = $NotebookInteractiveRunEnabled
        }
    }

    if ($poolParamsProvided -notcontains $false) {
        $body.pool = @{
            customizeComputeEnabled = $CustomizeComputeEnabled
            defaultPool = @{
                name = $DefaultPoolName
                type = $DefaultPoolType
            }
        }
    }

    if ($starterPoolParamsProvided -notcontains $false) {

        if ($starterPoolParamsProvided -notcontains $false) {
                $body.pool = @{
                    starterPool = @{
                        maxNodeCount = $StarterPoolMaxNodeCount
                        maxExecutors = $StarterPoolMaxExecutors
                    }
    
                }
        }
    }

    if ($PSBoundParameters.ContainsKey('EnvironmentName') -or $PSBoundParameters.ContainsKey('RuntimeVersion')) {
        $body.environment = @{
            name = $EnvironmentName
            runtimeVersion = $RuntimeVersion
        }
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    $endpoint = "workspaces/$WorkspaceId/spark/settings"

    $response = Invoke-FabricRestAPI -Endpoint $endpoint -Verb "PATCH" -Payload $bodyJson
    return $response
}