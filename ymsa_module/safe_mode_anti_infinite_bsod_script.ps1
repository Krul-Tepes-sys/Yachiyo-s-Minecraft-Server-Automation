. "$($PSScriptRoot)\function_new_makestar_alarm_dialog.ps1"
New-MakeStarAlarmDialog `
    -NoticeOnly `
    -Level Orange `
    -Text "因意外退出进入安全模式" `
    -HelpPath "$($PSScriptRoot)\safe_mode_anti_infinite_bsod_help.txt"