# Import the List-Workspaces function
. $PSScriptRoot\Private\Invoke-FabricRestAPI.ps1

. $PSScriptRoot\Workspace\Get-WorkspaceRoleAssignments.ps1
. $PSScriptRoot\Workspace\Get-Workspaces.ps1
. $PSScriptRoot\Workspace\New-Workspace.ps1
. $PSScriptRoot\Workspace\New-WorkspaceRoleAssignment.ps1
. $PSScriptRoot\Workspace\Remove-Workspace.ps1

. $PSScriptRoot\FabricItem\Get-FabricItem.ps1
. $PSScriptRoot\FabricItem\Get-FabricItemDefinition.ps1
. $PSScriptRoot\FabricItem\Get-FabricItems.ps1
. $PSScriptRoot\FabricItem\New-FabricItem.ps1
. $PSScriptRoot\FabricItem\Remove-FabricItem.ps1
. $PSScriptRoot\FabricItem\Update-FabricItem.ps1
. $PSScriptRoot\FabricItem\Update-FabricItemDefinition.ps1

. $PSScriptRoot\Notebook\Get-NotebookDefinition.ps1
. $PSScriptRoot\Notebook\Get-Notebooks.ps1
. $PSScriptRoot\Notebook\New-Notebook.ps1
. $PSScriptRoot\Notebook\Remove-Notebook.ps1
. $PSScriptRoot\Notebook\Update-NotebookDefinition.ps1
