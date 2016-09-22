<#
    .SYSNOPSIS

    My Custom PSScriptAnalyzerRules
    
    .NOTES

    https://msdn.microsoft.com/en-us/library/system.management.automation.language(v=vs.85).aspx
#>

Try {
    Get-ChildItem -Path "$PSScriptRoot\functions" -Filter *.ps1  | Select -ExpandProperty FullName | ForEach-Object {
        $Function = Split-Path $_ -Leaf
        . $_
    }
} 
Catch {
    Write-Warning ("Could not load {0}: {1}" -f $Function,$_.Exception.Message)
    Continue
}         

Export-ModuleMember Measure-*
