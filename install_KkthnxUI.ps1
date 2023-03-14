<#
.SYNOPSIS
Downloads the latest KkthnxUI UI replacement addon for World of Warcraft and places it in the selected location (chosen by the user)

Author: Beard
Version 1.0.8

#>

# Define parameters
param (
    [string]$Url = "https://github.com/Kkthnx-Wow/KkthnxUI/archive/refs/heads/master.zip",
    [string]$OutFile = "$PSScriptRoot\kkthnx_master.zip"
    #[string]$DestinationPath = "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns"
)
#Load System.Windows.Forms assembly
Add-Type -AssemblyName System.Windows.Forms

#Welcome Banner
Write-Output "##############################################"
Write-Output "#                                            #"
Write-Output "#             KkthnxUI Installer             #"
Write-Output "#                                            #"
Write-Output "##############################################"

# Use Invoke-WebRequest to download the file
Write-Host "Downloading KkthnxUI master.zip to $PSScriptRoot"
    Try {

        Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
    }
    Catch {

        Write-Host "Download failed." -ForegroundColor Red
        Write-Host $Error[0]

    }
    if ($?) {

        Write-Host "Successfully downloaded kkthnx_master.zip." -ForegroundColor Green

    }
# Unzip to location
Write-Host "Unzipping master.zip to $PSScriptRoot\kkthnx-temp..."
    Try {

        Expand-Archive -LiteralPath $OutFile -DestinationPath "$PSScriptRoot\kkthnx-temp" -Force

    }
    Catch {

        Write-Host "Unzip failed." -ForegroundColor Red
        Write-Host $Error[0]

    }
   
# Copy to location
Write-Host "Copying Kkthnxui folder to WoW addons folder. Please select the folder location..."
    Try {
        $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog

        # Set the initial folder to C:\
        $FolderBrowser.RootFolder = "MyComputer"
        $FolderBrowser.SelectedPath = "C:\Program Files (x86)\World of Warcraft"

        # Set the dialog title
        $FolderBrowser.Description = "Select a destination folder for KKthnxUI"
        # Show the dialog and get the user input
        $Result = $FolderBrowser.ShowDialog()

        # Check if the user clicked OK
        if ($Result -eq "OK") {
            # Get the selected folder path  
            $DestinationPath = $FolderBrowser.SelectedPath
        }
        else {
         # Exit the script if the user clicked Cancel
        Write-Host "User canceled. Terminating script." -ForegroundColor Red
        Exit
        }
        Write-Host "Copying folder to $DestinationPath..."
        Copy-item -Path "$PSScriptRoot\kkthnx-temp\kkthnxui-master\kkthnxui" -Destination $DestinationPath -Recurse -Force -ErrorAction Stop
    }
    Catch {

        Write-Host "Copy failed." -ForegroundColor Red
        Write-Host $Error[0] -ForegroundColor Yellow

    }

# Cleanup
    Write-Host "Cleaning up some leftovers..."
    Try {

        Remove-Item -Path "$PSScriptRoot\kkthnx_master.zip"

    }
    Catch {

        Write-Host "Failed to delete kkthnx_master.zip." -ForegroundColor Red
        Write-Host $Error[0]

    }
    if ($?) {

        Write-Host "Kkthnx_master.zip successfully deleted." -ForegroundColor Green

    }
    Try {

        Remove-Item -Path "$PSScriptRoot\kkthnx-temp\KkthnxUI-master" -Recurse
    }
    Catch {

        Write-Host "Failed to delete the KkthnxUI-Master folder." -ForegroundColor Red
        Write-Host $Error[0]

    }
    if ($?) {

        Write-Host "KkthnxUI-Master folder successfully deleted." -ForegroundColor Green

    }
    Try {

        Remove-Item -Path "$PSScriptRoot\kkthnx-temp" -Recurse
    }
    Catch {

        Write-Host "Failed to delete the kkthnx-temp folder." -ForegroundColor Red
        Write-Host $Error[0]

    }
    if ($?) {

        Write-Host "Kkthnx-temp folder successfully deleted." -ForegroundColor Green

    }
$ExitPrompt = $(Write-Host "End of script. Press Enter to exit!" -ForegroundColor Cyan -NoNewLine) + $(Read-Host)
$ExitPrompt
