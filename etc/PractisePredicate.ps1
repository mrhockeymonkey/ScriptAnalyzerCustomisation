#https://msdn.microsoft.com/en-us/library/system.management.automation.language(v=vs.85).aspx


$ScriptBlockAst = ([ScriptBlock]::Create($(gc C:\Users\Scott\OneDrive\Github\deleteme.ps1 -raw))).Ast

[ScriptBlock]$Predicate = {
    Param ([System.Management.Automation.Language.Ast]$Ast)

    [bool]$ReturnValue = $False
    If ($Ast -is [System.Management.Automation.Language.NamedBlockAst]) {
          
          
          [bool]$returnValue = $True  
    }
    return $ReturnValue
}

 [System.Management.Automation.Language.Ast[]]$Violations = $ScriptBlockAst.FindAll($Predicate, $True)
 $Violations