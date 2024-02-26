#* Sample command: .\DeleteFiles.ps1 -Folder .\ -Recurse -FileExtension *.js,*.js.map

#! Use -WhatIf to safely test it without accidentally deleting files.

# DeleteFiles.ps1
[CmdletBinding(SupportsShouldProcess)]
param (
    # The top folder path
    [Parameter(Mandatory)]
    [String]
    $Folder,

    # File extensions to include
    [Parameter(Mandatory)]
    [string[]]
    $FileExtension,

    # Switch to do a recursive deletion
    [Parameter()]
    [switch]
    $Recurse
)

# Compose the Get-ChildItem parameters.
$fileSearchParams = @{
    Path    = $Folder
    Recurse = $Recurse
    File    = $true
    Force   = $true
}
if ($FileExtension) { $fileSearchParams += @{Include = $FileExtension } }

# Get items inside path
$folderCollection = Get-ChildItem

foreach ($folder in $folderCollection) {
    # Check if child item is a folder
    if ( Test-Path -Path $folder -PathType Container) {
        # Get files inside folder based on parameters
        $fileCollection = Get-ChildItem @fileSearchParams
    
        # Delete them.
        foreach ($file in $fileCollection) {
            
            # Process each file
            Try {
                Remove-Item $file -Force -ErrorAction Stop
                if (!($PSBoundParameters.ContainsKey('WhatIf'))) {
                    "Deleted: $($file)" | Out-Default
                }
            }
            Catch {
                "Failed: $($_.Exception.Message)" | Out-Default
            }
        }   
    }
}