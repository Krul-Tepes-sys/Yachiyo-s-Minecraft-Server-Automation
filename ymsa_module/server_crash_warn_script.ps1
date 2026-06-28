. "$($PSScriptRoot)\function_new_makestar_alarm_dialog.ps1"
New-MakeStarAlarmDialog `
    -NoticeOnly `
    -Level Yellow `
    -Text "你服务器炸了" `
    -HelpPath "$($PSScriptRoot)\server_crash_warn_help.txt"