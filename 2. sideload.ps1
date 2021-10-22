param(
    [Parameter(Mandatory = $false)]
    [switch]$shouldAssumeToBeElevated,

    [Parameter(Mandatory = $false)]
    [String]$workingDirOverride
)

# If parameter is not set, we are propably in non-admin execution. We set it to the current working directory so that
#  the working directory of the elevated execution of this script is the current working directory
if (-not($PSBoundParameters.ContainsKey('workingDirOverride'))) {
    $workingDirOverride = (Get-Location).Path
}

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# If we are in a non-admin execution. Execute this script as admin
if ((Test-Admin) -eq $false) {
    if ($shouldAssumeToBeElevated) {
        Write-Output "Administrator Permission(UAC) is required to sideload Windows Subsystem for Android(TM)"
    }
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -shouldAssumeToBeElevated -workingDirOverride "{1}"' -f ($myinvocation.MyCommand.Definition, "$workingDirOverride"))
    }
    exit
}
Set-Location "$workingDirOverride"
try {
    Write-Output "Sideloading Windows Subsystem for Android(TM)..."
    $sideloadedWSA = $env:APPDATA + '\SideloadedWSA\'
    $_sideloadedWSA = $env:APPDATA + '\_SideloadedWSA\'
    $appxmanifest = $sideloadedWSA + '\AppxManifest.xml'
    if ((Test-Path $sideloadedWSA) ) { Remove-Item $sideloadedWSA -Recurse -Force | Out-Null }
    if ((Test-Path $_sideloadedWSA) ) { Remove-Item $_sideloadedWSA -Recurse -Force | Out-Null }
    New-Item $_sideloadedWSA -ItemType Directory -ea 0 | Out-Null
    Copy-Item .\* $_sideloadedWSA -Recurse -Force
    Move-Item $_sideloadedWSA $sideloadedWSA
    Add-AppxPackage -Register $appxmanifest
    Write-Output "Sideloaded Windows Subsystem for Android(TM)..."
}
catch {
    Write-Output "There was error while sideloading Windows Subsystem for Android(TM)..."
    Write-Output "$PSItem"
}
