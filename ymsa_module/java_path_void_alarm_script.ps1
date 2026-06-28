. "$($PSScriptRoot)\function_new_makestar_alarm_dialog.ps1"
New-MakeStarAlarmDialog `
    -NoticeOnly `
    -Level Red `
    -Text "Java路径无效" `
    -HelpPath "$($PSScriptRoot)\java_path_void_alarm_help.txt"