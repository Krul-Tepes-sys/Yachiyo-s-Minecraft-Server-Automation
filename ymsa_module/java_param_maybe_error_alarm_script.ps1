. "$($PSScriptRoot)\function_new_makestar_alarm_dialog.ps1"
New-MakeStarAlarmDialog `
    -NoticeOnly `
    -Level Red `
    -Text "Java参数可能出错" `
    -HelpPath "$($PSScriptRoot)\java_param_maybe_error_alarm_help.txt"