Write-Host @'
============================================
Yachiyo's Minecraft Server Automation (YMSA)
============================================
'@

. "$($PSScriptRoot)\ymsa_module\function_new_makestar_alarm_dialog.ps1"
. "$($PSScriptRoot)\ymsa_module\function_new_async_notice.ps1"

try {
    $userConfigRaw = Get-Content "$($PSScriptRoot)\ymsa_module\user_config.json" -Raw -ErrorAction Stop
    $userConfig = ConvertFrom-Json $userConfigRaw -ErrorAction Stop
}
catch {
    New-AsyncNotice -ScriptPath "$($PSScriptRoot)\ymsa_module\json_error_alarm_script.ps1"
    exit
}