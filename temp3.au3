$NAS_IP="192.168.192.1"

Local $text=StringLeft( $NAS_IP, StringInStr($NAS_IP, ".", 0, 3)-1)



MsgBox(0, "New string is", $text)



