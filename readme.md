# Yachiyo's Minecraft Server Automation (YMSA)
更好的Minecraft服务器自动化运行脚本

## 介绍
### 核心功能
- 自动重启：崩服后自动重新开服
- 防无限崩溃：15分钟内连崩三次停服保护（可自定义时间）
- 防无限死机：因服务端导致电脑死机，重启后不会因为开机自启再次死机
### 相比于第一代改进
- 兼容Windows PowerShell，不再强制要求PS7
- 不再依赖PSToml模块
- 不再依赖BurntToast模块

## 使用方法
- 点右上角绿色Code，点Download Zip（或者克隆仓库）
- 解压并复制内容到你的服务端根目录
- 编辑.\ymsa_module\user_config.json
```json
{
    "javaPath": "", //Java路径，要精确到bin\java.exe
    "javaArgs": [], //Java参数，可以从服务器默认的启动脚本中复制过来，需要重新格式化成数组，如果不懂可以询问AI
    "carshTimeLimit": 900 //在多少秒内服务端连崩三次停服保护
}
```
⚠ **不要学上面的代码块在Json里写注释，会炸的**
- 双击ymsa_run.bat启动
- （可选）使用ymsa_run_with_pwsh.bat用PS7启动
- （可选）手动添加开机自启动

## 许可证
- GPLv3