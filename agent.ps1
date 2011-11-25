## giraffi agent script
# [Diagnostics.EventLog]::WriteEntry("Giraffi Agent", "test ok", "Warning", 0)

# constant
function addConst {
  Set-Variable $args[0] $args[1] -Option Constant -Scope script
}
addConst version "prototype 1.0"
addConst agent_dir "c:\opt\agent\"
addConst apikey_file "apikey.txt"
addConst ck_file "customkey.txt"
addConst log_file "agent.log"


## Host Env
$hostname = $Env:COMPUTERNAME
# config value of interface who has DefaultIPGateway
$mac_address = $(Get-WmiObject Win32_NetworkAdapterConfiguration | Where { $_.DefaultIPGateway -ne $NULL }).MACAddress
$ip_address = $(Get-WmiObject Win32_NetworkAdapterConfiguration | Where { $_.DefaultIPGateway -ne $NULL }).IPAddress[0]

## script env
# put your apikey to $agent_dir$apikey_file
$g_uri        = "https://okapi.giraffi.jp:3007/internal/nodelayed"
$g_apikey     = ($(Get-Content  "$agent_dir$apikey_file") -replace "`r`n",'')
$customkey = $mac_address
# $customkey = "windows"


## post function
function post2Giraffi {
  $wc = new-object net.WebClient
 
  $wc.QueryString.Add("apikey", $g_apikey)
  $wc.Headers.Add("Content-Type","application/json")
  $wc.Headers.Add("Accept","application/json")


  # $mem_used = $(Get-WmiObject -Class Win32_PerfFormattedData_PerfOS_Memory).PercentCommittedBytesInUse

  # $utime = [int][double]::Parse((Get-Date -UFormat %s))
  $utime = [int][double]::Parse($(New-TimeSpan $([datetime]'1/1/1970') $([TimeZone]::CurrentTimeZone.ToUniversalTime((get-date)))).TotalSeconds)

  $s_type  = $args[0]
  $s_value = $args[1]

  $data = "{
    ""internal"":{
      ""servicetype"":""$s_type"",
      ""value"":$s_value,
      ""customkey"":""$customkey"",
      ""ck_init"":""$customkey"",
      ""tags"":[""$ip_address"",""$mac_address"",""$hostname""],
      ""checked_at"":""$utime""
    }
  }"

  $data
  $wr = $wc.UploadString($g_uri, $data)

  $wc.Quit    
}


## post memory used
$mem_used = $(Get-WmiObject -Class Win32_PerfFormattedData_PerfOS_Memory).PercentCommittedBytesInUse
post2Giraffi mem_used $mem_used



trap {
  [Diagnostics.EventLog]::WriteEntry("Giraffi Agent", $error[0].Exception, "Error", 1)
  continue
}
