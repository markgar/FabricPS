try {
    Import-Module '.\FabricPS' -Force
    
    $capacityId = '11E25ED5-7B83-4C7A-9ECD-EBF8F667CA20'
    $principalId = '60bf0b41-0484-466b-8b46-ebb6692bd8cc'
    $workspaceName = 'Automated_Test_Workspace'
    
    Write-Host 'Get-Workspaces'
    $workspaces = Get-Workspaces
    $existingWorkspace = $workspaces.value | Where-Object { $_.DisplayName -eq $workspaceName }
    if ($existingWorkspace) {
        Write-Host 'Remove-Workspace'
        Remove-Workspace -WorkspaceId $existingWorkspace.id
    }
    Write-Host 'New-Workspace'
    $workspace = New-Workspace -DisplayName $workspaceName -Description 'A test workspace' -CapacityId $capacityId
    Write-Host 'New-WorkspaceRoleAssignment'
    New-WorkspaceRoleAssignment -WorkspaceId $workspace.id -PrincipalId $principalId -PrincipalType 'User' -WorkspaceRole 'Admin'
    Write-Host 'Get-WorkspaceRoleAssignments'
    Get-WorkspaceRoleAssignments -WorkspaceId $workspace.id
    
    Write-Host 'New-Lakehouse (Test_Lakehouse)'
    $lakehouse = New-Lakehouse -WorkspaceId $workspace.id -DisplayName 'Test_Lakehouse' -Description 'A test lakehouse'
    Write-Host 'Remove-Lakehouse (Test_Lakehouse)'
    Remove-Lakehouse -WorkspaceId $workspace.id -LakehouseId $lakehouse.id

    Write-Host 'New-Lakehouse Test_Lakehouse_2'
    $lakehouse = New-Lakehouse -WorkspaceId $workspace.id -DisplayName 'Test_Lakehouse_2'
    Write-Host 'Get-Lakehouses'
    Get-Lakehouses -WorkspaceId $workspace.id
    Wirte-Host 'Get-Lakehouse (Test_Lakehouse_2)'
    Get-Lakehouse -WorkspaceId $workspace.id -LakehouseId $lakehouse.id
  
    # upload a file
    $ctx = New-AzStorageContext -StorageAccountName 'onelake' -UseConnectedAccount -Endpoint 'fabric.microsoft.com'
    $filePath = "./scripts/abc123.csv"
    $blobContainerName = $workspace.Id
    $blobName = $lakehouse2.Id + "/Files/abc123.csv"
    Set-AzStorageBlobContent -File $filePath -Container $blobContainerName -Blob $blobName -Context $ctx

    Write-Host 'New-Notebook'
    $notebook = New-Notebook -WorkspaceId $workspace.id -DisplayName 'Test_Notebook' -Description 'A test notebook'
    Write-Host 'New-Notebook'
    $anotherNotebook = New-Notebook -WorkspaceId $workspace.id -DisplayName 'Test_Notebook_2'
    Write-Host 'Get-NotebookDefinition'
    Get-NotebookDefinition -WorkspaceId $workspace.id -NotebookId $notebook.id
    Write-Host 'Get-Notebooks'
    Get-Notebooks -WorkspaceId $workspace.id
    # Update-NotebookDefinition -WorkspaceId $workspace.id -NotebookId $notebook.id -DisplayName 'Updated Notebook'
    Write-Host 'Remove-Notebook'
    Remove-Notebook -WorkspaceId $workspace.id -NotebookId $notebook.id
    
    Write-Host 'Get-FabricItems'
    Get-FabricItems -WorkspaceId $workspace.id -Type 'Notebook'
    Write-Host 'Get-FabricItemDefinition'
    Get-FabricItemDefinition -WorkspaceId $workspace.id -ItemId $anotherNotebook.id
    Write-Host 'Get-FabricItems'
    Get-FabricItems -WorkspaceId $workspace.id -Type 'Notebook'
    Write-Host 'New-FabricItem'
    New-FabricItem -WorkspaceId $workspace.id -Type 'Notebook' -DisplayName 'Created_by_Create_Item'
    Write-Host 'Remove-FabricItem'
    Remove-FabricItem -WorkspaceId $workspace.id -ItemId $anotherNotebook.id
    # Update-FabricItem -WorkspaceId $workspace.id -ItemId $anotherNotebook.id -DisplayName 'Updated by Update Item'
}
catch {
    Write-Error "An error occurred: $_"
    exit 1
}

