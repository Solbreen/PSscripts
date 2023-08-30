<#
.SYNOPSIS
    A short one-line action-based description, e.g. 'Tests if a function is valid'
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>

$Uri = 'https://drive.google.com/uc?export=download&id=19nI8JJVagEyc_YjP3xZDneVCbdztx7my'
$tempkatalog = "$PSScriptroot\$(get-random -minimum 100000000 -maximum 100000000000000000)"
$QLocation = "$env:LOCALAPPDATA"
$qfile = "$tempkatalog\q.zip"
try {
    new-item -path "$tempkatalog" -ItemType Directory -ErrorAction Stop | Out-Null
}
catch {
    throw "$($_.Exception.Message)"
}
try {
    Invoke-WebRequest -uri $Uri -OutFile $qfile -ErrorAction Stop
}
catch {
    throw "$($_.Exception.Message)"
}
Expand-Archive -path $qfile  -DestinationPath $QLocation
New-Item -Path "$QLocation\QTRANS*" -Name Data -ItemType Directory
$a = Invoke-WebRequest -uri 'https://raw.githubusercontent.com/Solbreen/PSscripts/main/OTHER/QtranslateScript/Options.json'
New-Item -Path "$QLocation\QTRANS*\Data" -Name 'Options.json' -ItemType File -Value $a.content | Out-Null


$Qexe = Get-Item "$env:LOCALAPPDATA\QTRANS*\*.exe"

$shell = New-Object -ComObject WScript.Shell
$lnk = $shell.CreateShortcut("$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup\Q.lnk")
$lnk.TargetPath = $Qexe.FullName
$lnk.Save()





Remove-Item -Path $tempkatalog -Recurse