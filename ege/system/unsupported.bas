'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_SYSTEM_UNSUPPORTED_BAS__
#Define __EGE_SYSTEM_UNSUPPORTED_BAS__
	
	Function MsgBox(Text As String, Title As String = "Message", Style As MsgBoxStyle = fbOkOnly) As Integer
		
		Return 0
		
	End Function
	
	Sub Terminate(code As Integer = 0)
		
		End code
		
	End Sub
	
	Sub SetWindowIcon(resId As Integer = 1)
		
	End Sub
	
	#Define _EGE_SYSTEM_SYSMODAL_BOX_ 0
	#Define _NEW_LINE_ !"\n"


#EndIf
