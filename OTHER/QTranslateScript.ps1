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

$Qexe = Get-Item "$env:LOCALAPPDATA\QTRANS*\*.exe"

$shell = New-Object -ComObject WScript.Shell
$lnk = $shell.CreateShortcut("$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup\Q.lnk")
$lnk.TargetPath = $Qexe.FullName
$lnk.Save()





Remove-Item -Path $tempkatalog -Recurse