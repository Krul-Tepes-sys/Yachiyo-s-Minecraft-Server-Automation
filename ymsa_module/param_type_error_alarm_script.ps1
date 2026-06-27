. "$($PSScriptRoot)\function_new_makestar_alarm_dialog.ps1"
New-MakeStarAlarmDialog `
    -NoticeOnly `
    -Level Red `
    -Text "参数类型错误" `
    -HelpPath "$($PSScriptRoot)\param_type_error_alarm_help.txt"