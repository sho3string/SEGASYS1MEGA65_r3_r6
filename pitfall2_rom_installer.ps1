# Up'n Down ROM Builder - PowerShell 5.1+
Clear-Host

$WorkingDirectory = Get-Location
$OutputPath = Join-Path $WorkingDirectory "arcade\pitfall2"

# XOR Table for encryption
$XORTable = [byte[]](
    0xA0,0x80,0xA8,0x88,0xA0,0x80,0xA8,0x88,
	0x08,0x88,0x28,0xA8,0x28,0xA8,0x20,0xA0,
	0xA0,0x80,0xA8,0x88,0xA0,0x80,0xA8,0x88,
	0xA0,0xA8,0x20,0x28,0xA0,0xA8,0x20,0x28,
	0xA0,0x80,0xA8,0x88,0x20,0x00,0xA0,0x80,
	0x28,0xA8,0x20,0xA0,0x20,0x00,0xA0,0x80,
	0xA0,0xA8,0x20,0x28,0xA0,0xA8,0x20,0x28,
	0x28,0xA8,0x20,0xA0,0xA0,0xA8,0x20,0x28,
	0x20,0x00,0xA0,0x80,0x80,0x88,0xA0,0xA8,
	0x80,0x88,0xA0,0xA8,0x80,0x88,0xA0,0xA8,
	0xA0,0xA8,0x20,0x28,0xA0,0x80,0xA8,0x88,
	0x80,0x88,0xA0,0xA8,0x28,0xA8,0x20,0xA0,
	0x20,0x00,0xA0,0x80,0x80,0x88,0xA0,0xA8,
	0x80,0x88,0xA0,0xA8,0x20,0x00,0xA0,0x80,
	0xA0,0xA8,0x20,0x28,0xA0,0x80,0xA8,0x88,
	0x80,0x88,0xA0,0xA8,0x28,0xA8,0x20,0xA0
)

	Write-Host "+-----------------------------------+"
	Write-Host "|  Building Pitall II Arcade ROMs   |"
	Write-Host "+-----------------------------------+"

	# Ensure directories
	New-Item -ItemType Directory -Force -Path $OutputPath | Out-Null

	# Build CPU ROM (concatenate files)
	$cpuRomFiles = @("epr6456a.116", "epr6457a.109")
	$cpuBytes = @()
	foreach ($file in $cpuRomFiles) {
		$cpuBytes += [System.IO.File]::ReadAllBytes((Join-Path $WorkingDirectory $file))
	}
	[System.IO.File]::WriteAllBytes((Join-Path $OutputPath "rom1.bin"), $cpuBytes)
	Write-Host "CPU ROM built"

	# Copy non-encrypted data
	$nonEncFiles = @("epr6458a.96")
	$nonEncBytes = @()
	foreach ($file in $nonEncFiles) {
		$nonEncBytes += [System.IO.File]::ReadAllBytes((Join-Path $WorkingDirectory $file))
	}
	[System.IO.File]::WriteAllBytes((Join-Path $OutputPath "epr-6458a.96"), $nonEncBytes)
	Write-Host "Non-encrypted ROM copied"

	# Copy sound ROM
	$sndRomFiles = @("epr-6462.120")
	$sndBytes = @()
	foreach ($file in $sndRomFiles) {
		$sndBytes += [System.IO.File]::ReadAllBytes((Join-Path $WorkingDirectory $file))
	}
	[System.IO.File]::WriteAllBytes((Join-Path $OutputPath "epr-6462.120"), $sndBytes)
	Write-Host "Sound ROM copied"
	

	# Copy tile ROMs
	$tileFiles = @("epr6474a.62", "epr6472a.64", "epr6470a.66", "epr6473a.61", "epr6471a.63", "epr6469a.65")
	foreach ($file in $tileFiles) {
		Copy-Item -Path (Join-Path $WorkingDirectory $file) -Destination $OutputPath
	}
	Write-Host "Tile ROMs copied"

	# Build sprite ROM (concatenate two files twice)
	$spriteFiles = @("epr6454a.117", "epr-6455.05", "epr6454a.117", "epr-6455.05")
	$spriteBytes = @()
	foreach ($file in $spriteFiles) {
		$spriteBytes += [System.IO.File]::ReadAllBytes((Join-Path $WorkingDirectory $file))
	}
	[System.IO.File]::WriteAllBytes((Join-Path $OutputPath "sprites.bin"), $spriteBytes)
	Write-Host "Sprite ROM built"

	# Copy lookup PROM
	Copy-Item -Path (Join-Path $WorkingDirectory "pr-5317.76") -Destination $OutputPath
	Write-Host "Lookup PROM copied"

	# Dump XOR table
	[System.IO.File]::WriteAllBytes((Join-Path $OutputPath "xortable.bin"), $XORTable)
	Write-Host "XOR table dumped"

	# Create empty PF2CFG file (filled with 0xFF)
	$length = 73
	$emptyBytes = ,0xFF * $length
	[System.IO.File]::WriteAllBytes((Join-Path $OutputPath "pf2cfg"), $emptyBytes)
	Write-Host "Blank pf2cfg created"
	Write-Host "All done!"
