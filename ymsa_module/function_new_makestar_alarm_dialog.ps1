function New-MakeStarAlarmDialog {
    param (
        [string]$Level = "White",
        [string]$Text = "默认文本",
        [switch]$NoOK,
        [switch]$NoMute,
        [switch]$NoHelp,
        [string]$OKText = "确定",
        [string]$MuteText = "关闭警报声",
        [string]$HelpText = "帮助",
        [string]$HelpPath,
        [switch]$NoticeOnly,
        [string]$ServerName = "未命名服务端"
    )
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    [System.Windows.Forms.Application]::EnableVisualStyles()
    try { [System.Windows.Forms.Application]::SetCompatibleTextRenderingDefault($false) } catch { <# 你就说它是不是不报错了 #> }
    $mainForm = New-Object System.Windows.Forms.Form
    # 外观
    $mainForm.Size = New-Object System.Drawing.Size(400, 200)
    $mainForm.FormBorderStyle = "Sizable"
    $mainForm.SizeGripStyle = "Hide"
    $dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    if ($Level -eq "Yellow") {
        $mainForm.BackColor = [System.Drawing.Color]::FromArgb(255,255,0)
        $mainForm.Text = "Warning - $($ServerName) - $($dateTime)"
    } elseif ($Level -eq "Orange") {
        $mainForm.BackColor = [System.Drawing.Color]::FromArgb(255,128,0)
        $mainForm.Text = "Warning - $($ServerName) - $($dateTime)"
    } elseif ($Level -eq "Red") {
        $mainForm.BackColor = [System.Drawing.Color]::FromArgb(255,0,0)
        $mainForm.Text = "Alarm - $($ServerName) - $($dateTime)"
    } else {
        $mainForm.BackColor = [System.Drawing.Color]::FromArgb(255,255,255)
        $mainForm.Text = "Information - $($ServerName) - $($dateTime)"
    }
    $mainForm.Icon = New-Object System.Drawing.Icon("$($PSScriptRoot)\chen_qianyu.ico")
    # 文本
    $txtLabel = New-Object System.Windows.Forms.Label
    $txtLabel.Location = New-Object System.Drawing.Point(12,20)
    $txtLabel.Size = New-Object System.Drawing.Size(360,82)
    $txtLabel.Font = New-Object System.Drawing.Font("宋体",14,[System.Drawing.FontStyle]::Bold)
    $txtLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $txtLabel.Text = $Text
    $mainForm.Controls.Add($txtLabel)
    # 确定按钮
    if (-not $NoOK) {
        $okButton = New-Object System.Windows.Forms.Button
        $okButton.Location = New-Object System.Drawing.Point(20,110)
        $okButton.Size = New-Object System.Drawing.Size(90,30)
        $okButton.BackColor = [System.Drawing.Color]::FromArgb(255,255,255)
        $okButton.Text = $OKText
        if ($NoticeOnly) {
            $okButton.Add_Click({
                $mainForm.Close()
            })
        } else {
            $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
        }
        $mainForm.Controls.Add($okButton)
    }
    # 关闭警报声按钮
    if (-not $NoMute) {
        $muteButton = New-Object System.Windows.Forms.Button
        $muteButton.Location = New-Object System.Drawing.Point(126,110)
        $muteButton.Size = New-Object System.Drawing.Size(130,30)
        $muteButton.BackColor = [System.Drawing.Color]::FromArgb(255,255,255)
        $muteButton.Text = $MuteText
        $muteButton.Add_Click({
            $muteButton.Enabled = $false
        })
        $mainForm.Controls.Add($muteButton)
    }
    # 帮助按钮
    if (-not $NoHelp) {
        $helpButton = New-Object System.Windows.Forms.Button
        $helpButton.Location = New-Object System.Drawing.Point(273,110)
        $helpButton.Size = New-Object System.Drawing.Size(90,30)
        $helpButton.BackColor = [System.Drawing.Color]::FromArgb(255,255,255)
        $helpButton.Text = $HelpText
        if ([string]::IsNullOrWhiteSpace($HelpPath)) {
            $helpButton.Enabled = $false
        }
        $helpButton.Add_Click({
            if (-not $null -eq $HelpPath) {
                Start-Process $HelpPath
            }
        })
        $mainForm.Controls.Add($helpButton)
    }
    # 限制
    $mainForm.MaximizeBox = $false
    $mainForm.MinimizeBox = $false
    # 显示
    if ($NoticeOnly) {
        $mainForm.Show()
        [System.Windows.Forms.Application]::Run($mainForm)
    } else {
        $mainForm.ShowDialog()
    }
    $mainForm.Dispose()
}