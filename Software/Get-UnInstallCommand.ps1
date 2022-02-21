<# 
 .DESCRIPTION
  This PowerShell Script will provide you the uninstall command required to remove software from your local machine  
     
 .PARAMETER -apps
  Name of the Application you want to check the command
  
 .EXAMPLE
 get-uninstallstrings -apps "chrome"
  
#>

## get-uninstallstrings -apps "chrome"

function get-uninstallstrings {
    [CmdletBinding()]
    Param(
    
        [Parameter(Mandatory=$false)]
        [Alias('program')]
        [String[]]$apps = "all"
        ) #close Param block

        $INSTALLED = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  Select-Object DisplayName, UninstallString
        $INSTALLED += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, UninstallString
        
        if ($apps -ne "all") { $INSTALLED | ?{ $_.DisplayName -like $("*$apps*") } | sort-object -Property DisplayName -Unique | Format-Table -AutoSize }
        else {$INSTALLED | ?{ $null -ne $_.DisplayName  } | sort-object -Property DisplayName -Unique | Format-Table -AutoSize}
    } #close function get uninstallstring
