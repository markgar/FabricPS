Import-Module '.\FabricPS' -Force

$capacityId = '11E25ED5-7B83-4C7A-9ECD-EBF8F667CA20'
$principalId = '60bf0b41-0484-466b-8b46-ebb6692bd8cc'

Write-Host 'Get-Workspaces'
$workspaces = Get-Workspaces
$workspaces
$existingWorkspace = $workspaces.value | Where-Object { $_.DisplayName -eq 'Test Workspace' }
if ($existingWorkspace) {
    Write-Host 'Remove-Workspace'
    Remove-Workspace -WorkspaceId $existingWorkspace.id
}
Write-Host 'New-Workspace'
$workspace = New-Workspace -DisplayName 'Test Workspace' -Description 'A test workspace' -CapacityId $capacityId
$workspace
Write-Host 'New-WorkspaceRoleAssignment'
New-WorkspaceRoleAssignment -WorkspaceId $workspace.id -PrincipalId $principalId -PrincipalType 'User' -WorkspaceRole 'Admin'
Write-Host 'Get-WorkspaceRoleAssignments'
Get-WorkspaceRoleAssignments -WorkspaceId $workspace.id

Write-Host 'New-Notebook'
$notebook = New-Notebook -WorkspaceId $workspace.id -DisplayName 'Test Notebook' -Description 'A test notebook'
Write-Host 'New-Notebook'
$anotherNotebook = New-Notebook -WorkspaceId $workspace.id -DisplayName 'Test Notebook 2'
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
New-FabricItem -WorkspaceId $workspace.id -Type 'Notebook' -DisplayName 'Created by Create Item'
Write-Host 'Remove-FabricItem'
Remove-FabricItem -WorkspaceId $workspace.id -ItemId $anotherNotebook.id
# Update-FabricItem -WorkspaceId $workspace.id -ItemId $anotherNotebook.id -DisplayName 'Updated by Update Item'