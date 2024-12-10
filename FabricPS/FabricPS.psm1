# Import the List-Workspaces function
. $PSScriptRoot\Private\Invoke-FabricRestAPI.ps1

. $PSScriptRoot\FabricItem\Get-FabricItem.ps1
. $PSScriptRoot\FabricItem\Get-FabricItemDefinition.ps1
. $PSScriptRoot\FabricItem\Get-FabricItems.ps1
. $PSScriptRoot\FabricItem\New-FabricItem.ps1
. $PSScriptRoot\FabricItem\Remove-FabricItem.ps1
. $PSScriptRoot\FabricItem\Update-FabricItem.ps1
. $PSScriptRoot\FabricItem\Update-FabricItemDefinition.ps1

. $PSScriptRoot\Lakehouse\Get-Lakehouse.ps1
. $PSScriptRoot\Lakehouse\Get-Lakehouses.ps1
. $PSScriptRoot\Lakehouse\New-Lakehouse.ps1
. $PSScriptRoot\Lakehouse\Remove-Lakehouse.ps1
. $PSScriptRoot\Lakehouse\Update-Lakehouse.ps1
. $PSScriptRoot\Lakehouse\Get-LakehouseTables.ps1
. $PSScriptRoot\Lakehouse\Invoke-LoadTable.ps1

. $PSScriptRoot\Notebook\Get-NotebookDefinition.ps1
. $PSScriptRoot\Notebook\Get-Notebooks.ps1
. $PSScriptRoot\Notebook\New-Notebook.ps1
. $PSScriptRoot\Notebook\Remove-Notebook.ps1
. $PSScriptRoot\Notebook\Update-NotebookDefinition.ps1

. $PSScriptRoot\Payloads\Get-NotebookDefinitionPayload.ps1
. $PSScriptRoot\Payloads\Get-ItemDefinitionPayload.ps1

. $PSScriptRoot\SemanticModel\Get-SemanticModel.ps1
. $PSScriptRoot\SemanticModel\Get-SemanticModelDefinition.ps1
. $PSScriptRoot\SemanticModel\Get-SemanticModels.ps1
. $PSScriptRoot\SemanticModel\New-SemanticModel.ps1
. $PSScriptRoot\SemanticModel\Remove-SemanticModel.ps1
. $PSScriptRoot\SemanticModel\Update-SemanticModel.ps1
. $PSScriptRoot\SemanticModel\Update-SemanticModelDefinition.ps1

. $PSScriptRoot\Spark\Get-WorkspaceSparkSettings.ps1
. $PSScriptRoot\Spark\Update-WorkspaceSparkSettings.ps1

. $PSScriptRoot\Workspace\Get-WorkspaceRoleAssignments.ps1
. $PSScriptRoot\Workspace\Get-Workspaces.ps1
. $PSScriptRoot\Workspace\New-Workspace.ps1
. $PSScriptRoot\Workspace\New-WorkspaceRoleAssignment.ps1
. $PSScriptRoot\Workspace\Remove-Workspace.ps1
