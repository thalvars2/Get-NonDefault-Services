<#
.SYNOPSIS
  A script to get all non-default services on a Windows machine.
.NOTES
  Version:        1.0
  Author:         Rickard Carlsson (@tzusec)
  Creation Date:  2020-08-29
#>

$server = "sltvxadc1","sltvxadc2","sltvxadc3","sltvxadc4","sltvxapvs1","sltvxapvs2","sltvxapvs3","sltvxapvs4"

$server | foreach{


$NonDefaultServices = @() 
$Services = Get-wmiobject win32_service -ComputerName $_  | where { $_.PathName -notmatch "policyhost.exe" -and $_.Name -ne "LSM" -and $_.PathName -notmatch "OSE.EXE" -and $_.PathName -notmatch "OSPPSVC.EXE" -and $_.PathName -notmatch "Microsoft Security Client" -and $_.DisplayName -notmatch "NetSetupSvc" -and $_.DisplayName -notmatch "VMware" -and $_.DisplayName -notmatch "McAfee" -and $_.DisplayName -notmatch "Microsoft Monitoring" -and $_.Caption -notmatch "Windows" -and $_.PathName -notmatch "Windows"  }



Foreach ($Service in $Services) {
    $NonDefaultServices+= [pscustomobject]@{
        DisplayName = $Service.DisplayName
        State = $Service.State
        StartMode = $Service.StartMode
        Status = $Service.Status
        ProcessID = $Service.ProcessId                
        ExePath = $Service.PathName
        Description = $Service.Description
        
    }
}

Write-Output "Server : $_ " 
Write-Output "Found $($NonDefaultServices.Count) non-default services."
Write-Output $NonDefaultServices |select displayname
Write-Output "------------------------------------------" 

}
