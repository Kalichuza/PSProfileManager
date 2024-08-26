@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'PSProfileManager.psm1'

    # Version number of this module.
    ModuleVersion = '1.0.2'

    # Supported PSEditions
    CompatiblePSEditions = @('Desktop', 'Core')

    # ID used to uniquely identify this module
    GUID = 'd2e9c735-4e6e-4d8d-b8d3-cc9d5ebdd4f9'

    # Author of this module
    Author = 'Kalichuza'

    # Company or vendor of this module
    CompanyName = 'Kalichuza'

    # Copyright statement for this module
    Copyright = '(c) 2024 Kalichuza. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'A PowerShell module to manage and load custom PowerShell profiles from URL or local paths.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Minimum version of the common language runtime (CLR) required by this module.
    CLRVersion = '4.0'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules = @()

    # Functions to export from this module
    FunctionsToExport = @('New-PSProfile', 'Test-PSProfile', 'Set-PSProfileSource', 'Import-PSProfile', 'Backup-PSProfile')

    # Cmdlets to export from this module
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module
    AliasesToExport = @()

    # DSC resources to export from this module
    DscResourcesToExport = @()

    # List of all files packaged with this module
    FileList = @('PSProfileManager.psm1', 'LICENSE', 'README.md', 'en-US\PSProfileManager-help.xml', 'en-US\PSProfileManager-help.txt')

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{}

    # Help info URI for this module
    HelpInfoURI = 'https://github.com/Kalichuza/PSProfileManager'

    # Default prefix to apply to commands exported from this module.
    DefaultCommandPrefix = ''
}
