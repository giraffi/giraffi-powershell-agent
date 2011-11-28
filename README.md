A resource monitoring agent for Windows Server
===
`giraffi-powershell-agent` is an agent for monitoring `Windows Server`.  

The agent installed in your server environment can collect and post data (memory usage and CPU load average)  
to the specific Giraffi API over SSL.  

The agent is designed to work with the `Windows Task Scheduler` so you can set up the agent to run whenever  
you like (once a day, every 5 minutes, etc.).  

The agent is a `Windows PowerShell` script. You’re free to examine and change its source code.

Requirements
---
* PowerShell 2.0 or later.
* Giraffi APIKEY. *[Giraffi](https://github.com/giraffi/) is a monitoring service.

Installation
---

1. Download this repository as a zip file from [https://github.com/giraffi/giraffi-powershell-agent/zipball/master](https://github.com/giraffi/giraffi-powershell-agent/zipball/master)
2. Extract the zip file.
3. Execute `install.bat` to open a command prompt.
4. Enter your Giraffi APIKEY and RETURN at the command prompt.
5. It enable you to insert the APIKEY into the file `C:\opt\agent\apikey.txt` and schedule the launch of `C:\opt\agent\agent.ps1` with Task Scheduler. The default value is `every 5 minutes`.

Notes
---
* The agent records an error in the `Event Log`.
* The default `Custom Key` value is a `MAC Address` dynamically detected from the NIC having the default gateway.
