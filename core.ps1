# Logo
Write-Host @'
============================================
Yachiyo's Minecraft Server Automation (YMSA)
============================================
'@

# 根据PS版本选择运行逻辑
# 我求你了不是5.1就一定要是7+，别给我从哪整个超冷门版本然后一个Issue过来问我为什么用不了
if ($PSVersionTable.PSVersion.Major -ge 7) {
    $usePwShSwitch = $true
} else {
    $usePwShSwitch = $false
}

# 导入函数
. "$($PSScriptRoot)\ymsa_module\function_new_makestar_alarm_dialog.ps1"
. "$($PSScriptRoot)\ymsa_module\function_new_async_notice.ps1"

# 用户配置检查
try {
    $userConfigRaw = Get-Content "$($PSScriptRoot)\ymsa_module\user_config.json" -Raw -ErrorAction Stop
    $userConfig = ConvertFrom-Json $userConfigRaw -ErrorAction Stop
}
catch {
    New-AsyncNotice `
        -ScriptPath "$($PSScriptRoot)\ymsa_module\json_error_alarm_script.ps1" `
        -UsePwSh $usePwShSwitch
    exit
}