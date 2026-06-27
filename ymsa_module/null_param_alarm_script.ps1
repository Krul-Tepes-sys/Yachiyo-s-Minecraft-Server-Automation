. "$($PSScriptRoot)\function_new_makestar_alarm_dialog.ps1"
New-MakeStarAlarmDialog `
    -NoticeOnly `
    -Level Red `
    -Text "必要参数为空" `
    -HelpPath "$($PSScriptRoot)\null_param_alarm_help.txt"