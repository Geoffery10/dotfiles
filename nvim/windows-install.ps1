# Winget Installer Script
$packages = @(
    "NeoVim.NeoVim"
    "Nushell"
    "zig.zig"
)

foreach ($package in $packages) {
    Write-Host "Installing $package..."
    winget install --id $package --accept-source-agreements
    if ($?) {
        Write-Host "Successfully installed $package."
    } else {
        Write-Host "Failed to install $package."
    }
}
