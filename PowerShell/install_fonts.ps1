<#
	.SYNOPSIS
		A PowerShell script that automates the installation of font files to 
		the system.
	
	.DESCRIPTION
		The script works by obtaining a list of all .ttf and .otf font files 
		that exist in subdirectories within the directory where the script is 
		executed from. It will then obtain the name of the font for each font 
		file and check if that font is registered in the Registry. If not, the 
		script will copy the font file to the C:\Windows\Fonts directory and 
		then register the font in the Registry.

	.NOTES
		@author Mick Pletcher
		@date 06/24/2021

		@author Aanish Pradhan
		@date 07/19/2022
#>

<#
	.SYNOPSIS
		Installs the font files.

	.DESCRIPTION
		Copies the font file to the C:\Windows\Fonts directory and registers 
		the font in the Registry.

	.PARAMETER FontFile
		The font file to install.
#>
function Install-Font {
	param
	(
		[Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][System.IO.FileInfo]$FontFile
	)
	
	#Get font name from the file's extended attributes
	$oShell = new-object -com shell.application
	$Folder = $oShell.namespace($FontFile.DirectoryName)
	$Item = $Folder.Items().Item($FontFile.Name)
	$FontName = $Folder.GetDetailsOf($Item, 21)
	try {
		switch ($FontFile.Extension) {
			".ttf" {$FontName = $FontName + [char]32 + '(TrueType)'}
			".otf" {$FontName = $FontName + [char]32 + '(OpenType)'}
		}
		$Copy = $true
		Write-Host ('Copying' + [char]32 + $FontFile.Name + '.....') -NoNewline
		Copy-Item -Path $fontFile.FullName -Destination ("C:\Windows\Fonts\" + $FontFile.Name) -Force
		
		#Test if font is copied over
		If ((Test-Path ("C:\Windows\Fonts\" + $FontFile.Name)) -eq $true) {
			Write-Host ('Success') -Foreground Yellow
		} else {
			Write-Host ('Failed') -ForegroundColor Red
		}
		$Copy = $false
		
		#Test if font registry entry exists
		If ((Get-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -ErrorAction SilentlyContinue) -ne $null) {
			
			#Test if the entry matches the font file name
			If ((Get-ItemPropertyValue -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") -eq $FontFile.Name) {
				Write-Host ('Adding' + [char]32 + $FontName + [char]32 + 'to the registry.....') -NoNewline
				Write-Host ('Success') -ForegroundColor Yellow
			} 
			else {
				$AddKey = $true
				Remove-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Force
				Write-Host ('Adding' + [char]32 + $FontName + [char]32 + 'to the registry.....') -NoNewline
				New-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $FontFile.Name -Force -ErrorAction SilentlyContinue | Out-Null
				If ((Get-ItemPropertyValue -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") -eq $FontFile.Name) {
					Write-Host ('Success') -ForegroundColor Yellow
				} else {
					Write-Host ('Failed') -ForegroundColor Red
				}
				$AddKey = $false
			}
		}
		else {
			$AddKey = $true
			Write-Host ('Adding' + [char]32 + $FontName + [char]32 + 'to the registry.....') -NoNewline
			New-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $FontFile.Name -Force -ErrorAction SilentlyContinue | Out-Null
			If ((Get-ItemPropertyValue -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") -eq $FontFile.Name) {
				Write-Host ('Success') -ForegroundColor Yellow
			} else {
				Write-Host ('Failed') -ForegroundColor Red
			}
			$AddKey = $false
		}
		
	}
	catch {
		If ($Copy -eq $true) {
			Write-Host ('Failed') -ForegroundColor Red
			$Copy = $false
		}
		If ($AddKey -eq $true) {
			Write-Host ('Failed') -ForegroundColor Red
			$AddKey = $false
		}
		write-warning $_.exception.message
	}
	Write-Host
}

$FontsFolder = ".\" # Current directory
$Fonts = Get-ChildItem -Directory -Path $FontsFolder # List of fonts

foreach ($Directory in $Fonts) {
	$FontList = Get-ChildItem -Path $Directory # List of font files

	foreach ($Font in $FontList) {
		Install-Font -Fontfile $Font # Install the font file
	}
}
