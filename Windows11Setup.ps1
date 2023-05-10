Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

#Install WinGet
#Based on this gist: https://gist.github.com/crutkas/6c2096eae387e544bd05cde246f23901
$hasPackageManager = Get-AppPackage -name 'Microsoft.DesktopAppInstaller'
if (!$hasPackageManager -or [version]$hasPackageManager.Version -lt [version]"1.10.0.0") {
    "Installing winget Dependencies"
    Add-AppxPackage -Path 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'

    $releases_url = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $releases = Invoke-RestMethod -uri $releases_url
    $latestRelease = $releases.assets | Where { $_.browser_download_url.EndsWith('msixbundle') } | Select -First 1

    "Installing winget from $($latestRelease.browser_download_url)"
    Add-AppxPackage -Path $latestRelease.browser_download_url
}
else {
    "winget already installed"
}

#Configure WinGet
Write-Output "Configuring winget"

#winget config path from: https://github.com/microsoft/winget-cli/blob/master/doc/Settings.md#file-location
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json";
$settingsJson = 
@"
    {
        // For documentation on these settings, see: https://aka.ms/winget-settings
        "experimentalFeatures": {
          "experimentalMSStore": true,
        }
    }
"@;
$settingsJson | Out-File $settingsPath -Encoding utf8

#Install New apps
Write-Output "Installing Apps"
$apps = @(
    @{name = "Microsoft.AzureCLI" }, 
    @{name = "Microsoft.PowerShell" }, 
    @{name = "Microsoft.VisualStudioCode" }, 
    @{name = "Microsoft.WindowsTerminal"; source = "msstore" }, 
    @{name = "Microsoft.Azure.StorageExplorer" }, 
    @{name = "Microsoft.PowerToys" }, 
    @{name = "Git.Git" },
    @{name = "GitHub.GitLFS" },
    @{name = "Docker.DockerDesktop" },
    @{name = "Microsoft.DotNet.SDK.6"  },
    @{name = "Microsoft.DotNet.SDK.7" },
    @{name = "Canonical.Ubuntu.2204" },
    @{name = "JanDeDobbeleer.OhMyPosh" },
    @{name = "Postman.Postman" },
    @{name = "Python.Python.3.10" },
    @{name = "OpenJS.NodeJS.LTS" },
    @{name = "Google.Chrome" },
    @{name = "Mozilla.Firefox" },
    @{name = "Microsoft.VisualStudio.2022.Enterprise" },
    @{name = "Spotify.Spotify" },
    @{name = "WhatsApp.WhatsApp" }
);

foreach ($app in $apps) {
    try {
        $listApp = winget list --exact -q $app.name --accept-source-agreements 
        if (![String]::Join("", $listApp).Contains($app.name)) {
            Write-Host "Installing: $($app.name)"
            if ($null -ne $app.source) {
                winget install --exact --silent $app.name --source $app.source --accept-package-agreements
            }
            else {
                winget install --exact --silent $app.name --accept-package-agreements
            }
        }
        else {
            Write-Host "Skipping install of $($app.name)"
        }
    }
    catch {
        Write-Output "Error installing $($app.name): $_"
    }
}

#Remove Apps
Write-Output "Removing Apps"

$apps = "*3DPrint*", "Microsoft.MixedReality.Portal", "Microsoft.SkypeApp"
foreach ($app in $apps) {
    try {
        Write-Host "Uninstalling $($app)"
        Get-AppxPackage -AllUsers $app | Remove-AppxPackage | Out-Null
    }
    catch {
        Write-Output "Error uninstalling $($app): $_"
    }
}

# Install WSL
# https://learn.microsoft.com/en-us/windows/wsl/install
Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -OutVariable WSLStatus | Out-Null
if ($WSLStatus.State -ne "Enabled") {
    wsl --install
} 
else {
    Write-Host "WSL already installed. Skipping..."
}

# Enable long paths
try {
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" `
        -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
}
catch {
    Write-Output "Error enabling long paths: $_"
}
