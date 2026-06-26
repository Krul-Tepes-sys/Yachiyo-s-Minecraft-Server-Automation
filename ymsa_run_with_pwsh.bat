chcp 65001 > nul
@echo off
pwsh.exe -ExecutionPolicy RemoteSigned -File ".\core.ps1"