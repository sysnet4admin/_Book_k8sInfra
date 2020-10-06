#!/bin/powershell
Param (
[Parameter(Mandatory=$true)]
$IPwPort
)

$i=0; while($true)
{
  % { $i++; write-host -NoNewline "$i $_" }
  (Invoke-RestMethod "http://$IPwPort")-replace '\n', " "
}