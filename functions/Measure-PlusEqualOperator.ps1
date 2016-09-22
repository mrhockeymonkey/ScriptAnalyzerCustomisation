<#
.SYNOPSIS
    You should not use += to add to an array.
.DESCRIPTION
    Arrays are Imutable which means using += actualy creates a new object and then adds all elements to this new object. 
    At high volumes this becomes very non perormant. 
    To fix this violation, instead create a System.Collection.Arraylist and use Add()
.EXAMPLE
    Measure-PlusEqualOperator -ScriptBlockAst $ScriptBlockAst
.INPUTS
    [System.Management.Automation.Language.ScriptBlockAst]
.OUTPUTS
    [Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]]
.NOTES
    https://msdn.microsoft.com/en-us/library/dd878270(v=vs.85).aspx
#>

Function Measure-PlusEqualOperator {
    [CmdletBinding()]
    [OutputType([Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord[]])]
    Param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst]
        $ScriptBlockAst
    )

    Process {

        $Results = @()

        Try {
            #A Predicate is a script block that returns True/False much like a filterScript
            [ScriptBlock]$Predicate = {
                Param ([System.Management.Automation.Language.Ast]$Ast)

                [bool]$ReturnValue = $False
                If ($Ast -is [System.Management.Automation.Language.AssignmentStatementAst]) {
                    If ($Ast.Operator -eq [System.Management.Automation.Language.TokenKind]::PlusEquals) {
                      [bool]$returnValue = $True  
                    }
                    ElseIf ($Ast.Operator -eq [System.Management.Automation.Language.TokenKind]::MinusEquals) {
                        [bool]$returnValue = $True
                    }
                }
                return $ReturnValue
            }


            #Finds ASTs that match the predicates.
            [System.Management.Automation.Language.Ast[]]$Violations = $ScriptBlockAst.FindAll($Predicate, $True)

            If ($Violations.Count -ne 0) {

                $Violations | ForEach-Object -Process {

                    $Result = New-Object `
                            -Typename "Microsoft.Windows.PowerShell.ScriptAnalyzer.Generic.DiagnosticRecord" `
                            -ArgumentList "$((Get-Help $MyInvocation.MyCommand.Name).Description.Text)",$_.Extent,$PSCmdlet.MyInvocation.InvocationName,Warning,$Null
          
                    $Results += $Result
                }
            }
            return $Results
            #endregion
        }
        Catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}