# PSProfileManager Module

# New-PSGlobalProfile function
function New-PSGlobalProfile {
    [CmdletBinding()]
    param (
        [switch]$Force,
        [switch]$Verbose
    )

    if (Test-PSGlobalProfile) {
        if (-not $Force) {
            Write-Warning "Profile already exists. Use -Force to overwrite."
            return
        }
    }

    New-Item -Path $PROFILE -ItemType File -Force
    if ($Verbose) {
        Write-Verbose "New profile created at $PROFILE"
    }
}

# Test-PSGlobalProfile function
function Test-PSGlobalProfile {
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

# Set-PSGlobalProfile function
function Set-PSGlobalProfile {
    [CmdletBinding()]
    param (
        [string]$Url,
        [string]$LocalPath,
        [switch]$Verbose
    )

    if ($Url) {
        $profileSource = $Url
        if ($Verbose) {
            Write-Verbose "Profile source set to URL: $Url"
        }
    } elseif ($LocalPath) {
        if (-not (Test-Path $LocalPath)) {
            Write-Error "Local path not found: $LocalPath"
            return
        }
        $profileSource = $LocalPath
        if ($Verbose) {
            Write-Verbose "Profile source set to local path: $LocalPath"
        }
    } else {
        Write-Error "No source specified. Use -Url or -LocalPath."
        return
    }

    # Store the profile source in a global variable or a persistent location
    $script:profileSource = $profileSource
}

# Load-PSGlobalProfile function
function Load-PSGlobalProfile {
    [CmdletBinding()]
    param (
        [switch]$FromUrl,
        [switch]$FromLocal,
        [switch]$Overwrite,
        [switch]$Append,
        [switch]$Reload,
        [switch]$Backup,
        [switch]$Verbose
    )

    if (-not $script:profileSource) {
        Write-Error "Profile source not set. Use Set-PSGlobalProfile first."
        return
    }

    if ($Backup) {
        Backup-PSGlobalProfile -Verbose:$Verbose
    }

    if ($FromUrl) {
        try {
            $profileContent = Invoke-WebRequest -Uri $script:profileSource -UseBasicParsing -ErrorAction Stop
            if ($Verbose) {
                Write-Verbose "Profile content retrieved from URL."
            }
        } catch {
            Write-Error "Failed to retrieve profile from URL: $_"
            return
        }
    } elseif ($FromLocal) {
        if (-not (Test-Path $script:profileSource)) {
            Write-Error "Local profile path not found: $script:profileSource"
            return
        }
        $profileContent = Get-Content -Path $script:profileSource -Raw
        if ($Verbose) {
            Write-Verbose "Profile content retrieved from local path."
        }
    } else {
        Write-Error "Specify -FromUrl or -FromLocal."
        return
    }

    if (Test-PSGlobalProfile) {
        if ($Overwrite) {
            Set-Content -Path $PROFILE -Value $profileContent -Force
            if ($Verbose) {
                Write-Verbose "Profile overwritten at $PROFILE"
            }
        } elseif ($Append) {
            Add-Content -Path $PROFILE -Value $profileContent
            if ($Verbose) {
                Write-Verbose "Profile content appended at $PROFILE"
            }
        } else {
            Write-Error "Profile already exists. Use -Overwrite or -Append."
            return
        }
    } else {
        Set-Content -Path $PROFILE -Value $profileContent -Force
        if ($Verbose) {
            Write-Verbose "New profile created and content set at $PROFILE"
        }
    }

    if ($Reload) {
        . $PROFILE
        if ($Verbose) {
            Write-Verbose "Profile reloaded into the current session."
        }
    }
}

# Backup-PSGlobalProfile function
function Backup-PSGlobalProfile {
    [CmdletBinding()]
    param (
        [switch]$Verbose
    )

    if (Test-PSGlobalProfile) {
        $backupPath = "$PROFILE.bak_$(Get-Date -Format 'yyyyMMddHHmmss')"
        Copy-Item -Path $PROFILE -Destination $backupPath -Force
        if ($Verbose) {
            Write-Verbose "Profile backed up to $backupPath"
        }
    } else {
        Write-Verbose "No existing profile to back up."
    }
}

# Export the module functions
Export-ModuleMember -Function New-PSGlobalProfile, Test-PSGlobalProfile, Set-PSGlobalProfile, Load-PSGlobalProfile, Backup-PSGlobalProfile
