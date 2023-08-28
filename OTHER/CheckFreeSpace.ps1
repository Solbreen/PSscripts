<#
.SYNOPSIS
    Проверка свободного места на диске С.
.DESCRIPTION
    Проверяет место на диске С. Если свободного места менее 25%, то появится окошко, предлагающее нажать "ок" или 

    нажать кнопку, которая открывает cleanmgr.exe.
.LINK
    https://github.com/Solbreen/PSscripts/blob/main/OTHER/CheckFreeSpace.ps1
#>


#region Создание всплывающего окошка
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
#endregion

#Условие для появления всплывающего окошка
$disk = get-cimInstance -ClassName win32_logicaldisk | where-object {$_.DeviceID -eq "C:"}
if($disk.FreeSpace/$disk.Size*100 -le 25){
    $form.ShowDialog()
}