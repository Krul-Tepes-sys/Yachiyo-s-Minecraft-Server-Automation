Write-Host @'
============================================
Yachiyo's Minecraft Server Automation (YMSA)
============================================
'@

. "$($PSScriptRoot)\ymsa_module\function_new_makestar_alarm_dialog.ps1"

try {
    $userConfigRaw = Get-Content "$($PSScriptRoot)\config.json" -Raw -ErrorAction Stop
    $userConfig = ConvertFrom-Json $userConfigRaw -ErrorAction Stop
}
catch {
    $null = New-MakeStarAlarmDialog `
        -Level Red `
        -Text "解析配置文件时出错" `
        -HelpPath "$($PSScriptRoot)\ymsa_module\json_error_alarm_help.txt"
}

$null = Read-Host "Press ENTER to Exit"