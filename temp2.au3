Local $sString
If Assign("sString", "Hello") Then MsgBox(4096, "Assign", $sString) ; This will print the text "Hello"



Local $a_b = 12
Local $s = Eval("a" & "_" & "b") ; $s is set to 12

$s = Eval("c") ; $s = "" and @error = 1

