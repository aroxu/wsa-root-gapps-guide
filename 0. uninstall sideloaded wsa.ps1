param(
    [Parameter(Mandatory = $false)]
    [switch]$shouldAssumeToBeElevated,

    [Parameter(Mandatory = $false)]
    [String]$workingDirOverride
)

if (-not($PSBoundParameters.ContainsKey('workingDirOverride'))) {
    $workingDirOverride = (Get-Location).Path
}

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false) {
    if ($shouldAssumeToBeElevated) {
        Write-Output "Administrator Permission(UAC) is required to uninstall Windows Subsystem for Android(TM)"
    }
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -shouldAssumeToBeElevated -workingDirOverride "{1}"' -f ($myinvocation.MyCommand.Definition, "$workingDirOverride"))
    }
    exit
}
Set-Location "$workingDirOverride"
try {
    Write-Output "Uninstalling Windows Subsystem for Android(TM)..."
    Get-AppxPackage "*.SideloadedWindowsSubsystemForAndroid*" | Remove-AppxPackage
    $sideloadedWSA = $env:APPDATA + '\SideloadedWSA'
    if ((Test-Path $sideloadedWSA) ) { Remove-Item $sideloadedWSA -Recurse -Force | Out-Null }
    Write-Output "Uninstalled Windows Subsystem for Android(TM)."
}
catch {
    Write-Output "There was error while uninstalling Windows Subsystem for Android(TM)..."
    Write-Output "$PSItem"
}
