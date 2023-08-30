<#
.SYNOPSIS
    Установщик QTranslate
.DESCRIPTION
    Скрипт качает архив с QTranslate с гуглдиска, разархивирует его в appdata\local,
    подтягивает с моего гита настройки options.json для программы в папку data в папке qtranslate, 
    на сам exe файл делается ссылка в автоматическом загрузчике, таким образом при каждом вхождении в сессию 
    загрузчик будет включать qtranslate автоматически, активировать его руками не нужно.
.LINK
    https://github.com/Solbreen/PSscripts/blob/main/OTHER/QtranslateScript/QTranslateScript.ps1
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