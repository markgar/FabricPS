function Deploy-FabricItems {
    param (
        [string]$DestinationWorkspaceId,
        [string]$Type
    )

    # Get all items of the specified type in the destination workspace
    $items = Get-FabricItems -Type $Type -WorkspaceId $DestinationWorkspaceId

    # Get all directories in the current directory that end with .Notebook
    $itemDirs = Get-ChildItem -Directory | Where-Object { $_.Name -like "*.$Type" }

    # Loop through each directory in the source which is a notebook
    foreach ($dir in $itemDirs) {

        # grab the item name, which is before the '.' in the directory name
        $ItemName = $dir.Name.Split('.')[0]
        
        $existingItem = $items.value | Where-Object { $_.DisplayName -eq $ItemName }

        # Check if the notebook already exists in the destination workspace
        if ($null -eq $existingItem) {
            
            $newItem = New-FabricItem `
                -WorkspaceId $DestinationWorkspaceId `
                -DisplayName $ItemName `
                -Type $Type
            
            # Set the notebookToUpdateId to the new notebook's Id so I can set the payload
            $itemToUpdateId = $newItem.Id
        } else {
            # Set the notebookToUpdateId to the existing notebook's Id so I can set the payload
            $itemToUpdateId = $existingItem.Id
        }
        
        if ($Type -eq 'Notebook') {  
            $payload = Get-NotebookDefinitionPayload -dir $dir
        }

        Update-FabricItemDefinition `
            -WorkspaceId $DestinationWorkspaceId `
            -ItemId $itemToUpdateId `
            -Definition $payload

        # todo - compare the list of notebooks in the destination that are in the source code
        # if the notebook is not in the source code, delete it from the destination
    }
}