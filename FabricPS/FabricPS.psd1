@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'FabricPS.psm1'

    # Version number of this module.
    ModuleVersion = '0.5.4'

    # ID used to uniquely identify this module
    GUID = '8231d005-a4a9-4c91-9791-cb7ad552edd4'

    # Author of the module
    Author = 'Mark Garner'

    # Description of the module
    Description = 'FabricPS module to manage and list workspaces.'

    # Functions to export from the module
    FunctionsToExport = @('*')

    # (Optional) PowerShell version required
    PowerShellVersion = '5.1'

    # (Optional) Required modules
    RequiredModules = @()

    # Copyright statement for this module
    Copyright = '(c) Mark Garner. All rights reserved.'

    # (Optional) Private data (can include help files, etc.)
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help people find the module in online galleries.
            Tags = @('Fabric', 'Management')

            # Release notes for this version of the module.
            ReleaseNotes = 'Initial release of FabricPS module.'
        }
    }
}