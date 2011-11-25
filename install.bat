@echo off
rem ## Giraffi internal agent setup script sample.
rem ## It works..
rem ##  - Change powershell execution-policy to remotesigned.
rem ##  - Create directory for agent "c:\opt\agent"
rem ##  - Copy powershell scripts to "c:\opt\agent"
rem ##    - for example, call powershell script to build agent.ps1 insted of copy.
rem ##  - Input apikey string from STDIN.
rem ##  - Create a new scheduled task for run agent every 5 minutes.

setlocal
rem ## Change directory to script dir.
set CuurentDirPath=%~dp0
cd /d "%CuurentDirPath%"


set AgentDirPath=c:\opt\agent\

rem # Set Executionpolicy.
rem powershell -Command "set-executionpolicy Unrestricted"
powershell -Command "set-executionpolicy remotesigned"

rem # create directory
IF NOT EXIST %AgentDirPath% mkdir %AgentDirPath%

rem # Copy or build script.
rem powershell build_agent.ps1
copy .\agent.ps1 %AgentDirPath% /Y

rem ## put apikey.
set /P APIKEY="Please paste GIRAFFI_APIKEY here > "
echo %APIKEY%>%AgentDirPath%apikey.txt

rem ## add task.
set TaskName=\Giraffi\Giraffi-Powershell-Agent
set Task=powershell %AgentDirPath%agent.ps1
set Schedule=DAILY
set ST=00:00
set RI=5
set DU=23:59
rem /F=Force
schtasks /create /tn "%TaskName%" /tr "%Task%" /sc %Schedule% /ri %RI% /st %ST% /du %DU% /ru "" /F

endlocal