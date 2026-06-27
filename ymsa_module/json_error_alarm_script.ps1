. "$($PSScriptRoot)\function_new_makestar_alarm_dialog.ps1"
New-MakeStarAlarmDialog `
    -NoticeOnly `
    -Level Red `
    -Text "解析Json配置文件时出错" `
    -HelpPath "$($PSScriptRoot)\json_error_alarm_help.txt"