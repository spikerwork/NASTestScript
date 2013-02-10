
$ScriptEndTime=GetUnixTimeStamp()
$ScriptEndTime=$ScriptEndTime-$ScriptStartTime
history ("Errors " & @error)
history ("Program halted. Worktime - " & $ScriptEndTime & " seconds.")
history ("------------------------------------------------------------------------")
;;; End of script

