# Logo
Write-Host @'
============================================
Yachiyo's Minecraft Server Automation (YMSA)
============================================
'@

# 根据PS版本选择运行逻辑
# 我求你了不是5.1就一定要是7+，别给我从哪整个超冷门版本然后一个Issue过来问我为什么用不了
if ($PSVersionTable.PSVersion.Major -ge 7) {
    $hasPwSh = Get-Command pwsh.exe -ErrorAction SilentlyContinue
    # 什么叫你的PS7是绿色版并且没手动加path？
    if ($hasPwSh) {
        $pSName = "pwsh.exe"
    } else {
        Write-Warning "使用了PS7但在PATH里找不到PS7，部分逻辑将降级使用PS5.1"
        $pSName = "powershell.exe"
    }
} else {
    $pSName = "powershell.exe"
}

# 用户配置检查
# 导入Json
try {
    $userConfigRaw = Get-Content "$($PSScriptRoot)\ymsa_module\user_config.json" -Raw -ErrorAction Stop
}
catch {
    $argList = @(
        "-ExecutionPolicy","RemoteSigned",
        "-File","$($PSScriptRoot)\ymsa_module\makestar_alarm_dialog.ps1",
        "-Level","Red",
        "-Text","导入Json文件失败（1）",
        "-HelpPath","$($PSScriptRoot)\ymsa_module\help.txt",
        "-ServerName","XX",
        "-NoticeOnly"
    )
    Start-Process -WindowStyle Hidden -FilePath $pSName -ArgumentList $argList
    exit
}
# 解析Json
try {
    $userConfig = ConvertFrom-Json $userConfigRaw -ErrorAction Stop
}
catch {
    $argList = @(
        "-ExecutionPolicy","RemoteSigned",
        "-File","$($PSScriptRoot)\ymsa_module\makestar_alarm_dialog.ps1",
        "-Level","Red",
        "-Text","解析Json文件失败（2）",
        "-HelpPath","$($PSScriptRoot)\ymsa_module\help.txt",
        "-ServerName","XX",
        "-NoticeOnly"
    )
    Start-Process -WindowStyle Hidden -FilePath $pSName -ArgumentList $argList
    exit
}
# Java路径空字符串校验
if ([string]::IsNullOrWhiteSpace($userConfig.javaPath)) {
    $argList = @(
        "-ExecutionPolicy","RemoteSigned",
        "-File","$($PSScriptRoot)\ymsa_module\makestar_alarm_dialog.ps1",
        "-Level","Red",
        "-Text","Java路径为空（3）",
        "-HelpPath","$($PSScriptRoot)\ymsa_module\help.txt",
        "-ServerName","`"$($userConfig.serverName)`"",
        "-NoticeOnly"
    )
    Start-Process -WindowStyle Hidden -FilePath $pSName -ArgumentList $argList
    exit
}
# 校验Java参数是不是数组
if (-not ($userConfig.javaArgs -is [array])) {
    # 萌新：哎这个方括号（数组）是什么？是不是写错了？我把它改成双引号（字符串）吧！这下对了！
    $argList = @(
        "-ExecutionPolicy","RemoteSigned",
        "-File","$($PSScriptRoot)\ymsa_module\makestar_alarm_dialog.ps1",
        "-Level","Red",
        "-Text","Java参数类型必须是数组（4）",
        "-HelpPath","$($PSScriptRoot)\ymsa_module\help.txt",
        "-ServerName","`"$($userConfig.serverName)`"",
        "-NoticeOnly"
    )
    Start-Process -WindowStyle Hidden -FilePath $pSName -ArgumentList $argList
    exit
}
# Java参数空数组校验
if ($userConfig.javaArgs.Count -eq 0) {
    $argList = @(
        "-ExecutionPolicy","RemoteSigned",
        "-File","$($PSScriptRoot)\ymsa_module\makestar_alarm_dialog.ps1",
        "-Level","Red",
        "-Text","Java参数为空（5）",
        "-HelpPath","$($PSScriptRoot)\ymsa_module\help.txt",
        "-ServerName","`"$($userConfig.serverName)`"",
        "-NoticeOnly"
    )
    Start-Process -WindowStyle Hidden -FilePath $pSName -ArgumentList $argList
    exit
}
# Java路径有效性校验
$javaPathFileName = Split-Path $userConfig.javaPath -Leaf -ErrorAction SilentlyContinue # 无视报错继续运行！
if ($javaPathFileName -ne "java.exe") {
    # 我不信哪个Java发行版的可执行文件不是java.exe
    # 别跟我提跨平台，真要跨平台首先WinForms直接就炸了
    $argList = @(
        "-ExecutionPolicy","RemoteSigned",
        "-File","$($PSScriptRoot)\ymsa_module\makestar_alarm_dialog.ps1",
        "-Level","Red",
        "-Text","Java路径无效（6）",
        "-HelpPath","$($PSScriptRoot)\ymsa_module\help.txt",
        "-ServerName","`"$($userConfig.serverName)`"",
        "-NoticeOnly"
    )
    Start-Process -WindowStyle Hidden -FilePath $pSName -ArgumentList $argList
    exit
}
if (-not (Test-Path $userConfig.javaPath)) {
    $argList = @(
        "-ExecutionPolicy","RemoteSigned",
        "-File","$($PSScriptRoot)\ymsa_module\makestar_alarm_dialog.ps1",
        "-Level","Red",
        "-Text","找不到Java路径指定的文件（7）",
        "-HelpPath","$($PSScriptRoot)\ymsa_module\help.txt",
        "-ServerName","`"$($userConfig.serverName)`"",
        "-NoticeOnly"
    )
    Start-Process -WindowStyle Hidden -FilePath $pSName -ArgumentList $argList
    exit
}

# 运行标记检查
if (Test-Path "$($PSScriptRoot)\ymsa_module\temp_running_flag") {
    New-AsyncNotice `
        -ScriptPath "$($PSScriptRoot)\ymsa_module\safe_mode_anti_infinite_bsod_script.ps1" `
        -UsePwSh $usePwShSwitch
    exit
} else {
    $null = New-Item "$($PSScriptRoot)\ymsa_module\temp_running_flag"
}

# 死循环启动！
$startDateTime = Get-Date
$crashCount = 0
while ($true) {
    & $userConfig.javaPath $userConfig.javaArgs
    $exitCode = $LASTEXITCODE
    if ($exitCode -eq 0) {
        Remove-Item "$($PSScriptRoot)\ymsa_module\temp_running_flag"
        exit
    } else {
        $crashCount++
        if ($crashCount -eq 1) {
            $firstCrashDateTime = Get-Date
            $runTimeSpan = $firstCrashDateTime - $startDateTime
            if ($runTimeSpan.TotalSeconds -le 15) {
                New-AsyncNotice `
                    -ScriptPath "$($PSScriptRoot)\ymsa_module\java_param_maybe_error_alarm_script.ps1" `
                    -UsePwSh $usePwShSwitch
                Remove-Item "$($PSScriptRoot)\ymsa_module\temp_running_flag"
                exit
            } else {
                New-AsyncNotice `
                    -ScriptPath "$($PSScriptRoot)\ymsa_module\server_crash_warn_script.ps1" `
                    -UsePwSh $usePwShSwitch
            }
        } elseif ($crashCount -eq 2) {
            $secondCrashDateTime = Get-Date
            $runTimeSpan = $secondCrashDateTime - $firstCrashDateTime
            if ($runTimeSpan.TotalSeconds -gt $userConfig.carshTimeLimit) {
                $crashCount = 0
            } else {
                New-AsyncNotice `
                    -ScriptPath "$($PSScriptRoot)\ymsa_module\server_crash_warn_script.ps1" `
                    -UsePwSh $usePwShSwitch
            }
        } elseif ($crashCount -ge 3) {
            $thirdCrashDateTime = Get-Date
            $runTimeSpan = $thirdCrashDateTime - $firstCrashDateTime
            if ($runTimeSpan.TotalSeconds -gt $userConfig.carshTimeLimit) {
                $crashCount = 0
            } else {
                New-AsyncNotice `
                    -ScriptPath "$($PSScriptRoot)\ymsa_module\safe_mode_anti_infinite_crash_script.ps1" `
                    -UsePwSh $usePwShSwitch
                Remove-Item "$($PSScriptRoot)\ymsa_module\temp_running_flag"
                exit
            }
        }
    }
}