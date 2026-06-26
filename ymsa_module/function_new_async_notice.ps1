function New-AsyncNotice {
    param (
        [string]$ScriptPath,
        [switch]$UsePwSh
    )
    if ($UsePwSh) {$psFileName = "pwsh.exe"} else {$psFileName = "powershell.exe"} # 你真的心甘情愿用一辈子PS5.1吗？
    Start-Process `
        -FilePath $psFileName `
        -WindowStyle Hidden `
        -ArgumentList "-ExecutionPolicy RemoteSigned", "-File", $ScriptPath
    # 我懒得写异常处理你最好别电脑都没装PS7然后你参数加个-UsePwSh
}