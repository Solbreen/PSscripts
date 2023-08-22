# Скрипт для проверки места на компе

Add-Type -Assemblyname System.Windows.Forms
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Warning!'
$label = New-Object System.Windows.Forms.Label
$label.Text = 'На вашем SSD места менее 25%!'
$label.Location = New-Object System.Drawing.Point 90,40
$form.Controls.Add($label)
$button1 = New-Object Windows.Forms.Button
$button1.Text = "Ок"
$button1.Location = New-Object System.Drawing.Point 50, 200
$form.Controls.Add($button1)
$button1.Add_Click({ $form.close() })
$button2 = New-Object Windows.Forms.Button
$button2.Text = "Очистка"
$button2.Location = New-Object System.Drawing.Point 150, 200
$form.Controls.Add($button2)
$button2.Add_Click({cleanmgr.exe; start-sleep -Milliseconds 700; $form.close()})
$form.TopMost = $True

$disk = get-cimInstance -ClassName win32_logicaldisk | where-object {$_.DeviceID -eq "C:"}
if($disk.FreeSpace/$disk.Size*100 -le 25){
    $form.ShowDialog()
}







#region Вариант, где создаётся уведомление с помощью BurntToast
<##Requires -Modules BurntToast
$disk = get-wmiobject -class win32_logicaldisk | where-object {$_.DeviceID -eq "C:"}
if($disk.FreeSpace/$disk.Size*100 -le 25){
    New-BurntToastNotification -text "Свободного места на диске С менее 25%!!!" -Sound Reminder
}#>
#endregion

#get-physicaldisk | where-object { $_.mediaType -eq "SSD"} | select-object -property <# место для еще одного свойства #>@{ name = "Size"; expr = { $_.size/1gb}}   - До лучших времён