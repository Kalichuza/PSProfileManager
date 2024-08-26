# PSProfileManager Module

# New-PSGlobalProfile function -> Rename to New-PSProfile
function New-PSProfile {
    [CmdletBinding()]
    param (
        [switch]$Force
    )

    if (Test-PSProfile) {
        if (-not $Force) {
            Write-Warning "Profile already exists. Use -Force to overwrite."
            return
        }
    }

    New-Item -Path $PROFILE -ItemType File -Force
    Write-Verbose "New profile created at $PROFILE"
}

# Test-PSGlobalProfile function -> Rename to Test-PSProfile
function Test-PSProfile {
    [CmdletBinding()]
    param ()

    if (Test-Path $PROFILE) {
        Write-Output $true
        Write-Verbose "Profile exists at $PROFILE"
    } else {
        Write-Output $false
        Write-Verbose "Profile does not exist."
    }
}

# Set-PSGlobalProfile function -> Rename to Set-PSProfileSource
function Set-PSProfileSource {
    [CmdletBinding()]
    param (
        [string]$Url,
        [string]$LocalPath
    )

    if ($Url) {
        $profileSource = $Url
        Write-Verbose "Profile source set to URL: $Url"
    } elseif ($LocalPath) {
        if (-not (Test-Path $LocalPath)) {
            Write-Error "Local path not found: $LocalPath"
            return
        }
        $profileSource = $LocalPath
        Write-Verbose "Profile source set to local path: $LocalPath"
    } else {
        Write-Error "No source specified. Use -Url or -LocalPath."
        return
    }

    # Store the profile source in a global variable or a persistent location
    $script:profileSource = $profileSource
}

# Load-PSGlobalProfile function -> Rename to Import-PSProfile
function Import-PSProfile {
    [CmdletBinding()]
    param (
        [string]$FromUrl,
        [string]$FromLocal,
        [switch]$Overwrite,
        [switch]$Append,
        [switch]$Reload,
        [switch]$Backup
    )

    if ($FromUrl) {
        $script:profileSource = $FromUrl
    } elseif ($FromLocal) {
        if (-not (Test-Path $FromLocal)) {
            Write-Error "Local profile path not found: $FromLocal"
            return
        }
        $script:profileSource = $FromLocal
    } else {
        Write-Error "Specify either -FromUrl or -FromLocal."
        return
    }

    if ($Backup) {
        Backup-PSProfile
    }

    try {
        $profileContent = if ($FromUrl) {
            Invoke-WebRequest -Uri $script:profileSource -UseBasicParsing -ErrorAction Stop | Select-Object -ExpandProperty Content
        } else {
            Get-Content -Path $script:profileSource -Raw
        }
        Write-Verbose "Profile content retrieved from $script:profileSource."
    } catch {
        Write-Error "Failed to retrieve profile from $script:profileSource: $_"
        return
    }

    if (Test-PSProfile) {
        if ($Overwrite) {
            Set-Content -Path $PROFILE -Value $profileContent -Force
            Write-Verbose "Profile overwritten at $PROFILE"
        } elseif ($Append) {
            Add-Content -Path $PROFILE -Value $profileContent
            Write-Verbose "Profile content appended at $PROFILE"
        } else {
            Write-Error "Profile already exists. Use -Overwrite or -Append."
            return
        }
    } else {
        Set-Content -Path $PROFILE -Value $profileContent -Force
        Write-Verbose "New profile created and content set at $PROFILE"
    }

    if ($Reload) {
        . $PROFILE
        Write-Verbose "Profile reloaded into the current session."
    }
}

# Backup-PSGlobalProfile function -> Rename to Backup-PSProfile
function Backup-PSProfile {
    [CmdletBinding()]
    param ()

    if (Test-PSProfile) {
        $backupPath = "$PROFILE.bak_$(Get-Date -Format 'yyyyMMddHHmmss')"
        Copy-Item -Path $PROFILE -Destination $backupPath -Force
        Write-Verbose "Profile backed up to $backupPath"
    } else {
        Write-Verbose "No existing profile to back up."
    }
}

# Export the module functions
Export-ModuleMember -Function New-PSProfile, Test-PSProfile, Set-PSProfileSource, Import-PSProfile, Backup-PSProfile
