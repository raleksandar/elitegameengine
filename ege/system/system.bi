'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_SYSTEM_BI__
#Define __EGE_SYSTEM_BI__
	
	#Undef System	' FreeBASIC's System statement cannot be used together with EGE, sorry...
	
	#Undef Assert	' #undef fb's Assert, EGE uses it's own (displays message box instead of writting to console)
	
	Namespace System
		
		Enum MsgBoxStyle
			fbOkOnly				= &h0
			fbOkCancel				= &h1
			fbAbortRetryIgnore		= &h2
			fbYesNoCancel			= &h3
			fbYesNo					= &h4
			fbRetryCancel			= &h5
			fbApplicationModal		= &h0
			fbCritical				= &h10
			fbQuestion				= &h20
			fbExclamation			= &h30
			fbInformation			= &h40
		End Enum
		
		Declare Function MsgBox(Text As String, Title As String = "Message", Style As MsgBoxStyle = fbOkOnly) As Integer
		
		Declare Sub Terminate(code As Integer = 0)
		
		Declare Sub SetWindowIcon(resId As Integer = 1)
		
		IncludeSource( "system.bas" )
	
	End Namespace
	
	#Macro Assert(expression)
		#If __FB_DEBUG__ 
			If (expression) = 0 Then			
				Elite.System.MsgBox( _
					"Expression: " + #expression + _NEW_LINE_ + _
					"Function: " + __FUNCTION__ + _NEW_LINE_ + _
					"File: " + __FILE__ + _NEW_LINE_ + _
					"Line: " + Str(__LINE__), _
					"Assertation failed", Elite.System.fbCritical Or _EGE_SYSTEM_SYSMODAL_BOX_)
				Elite.System.Terminate -1
			EndIf
		#EndIf
	#EndMacro
	
	#Macro Debug(msg)
		#If __FB_DEBUG__
			Elite.System.MsgBox(Str(msg), "Debug message", Elite.System.fbExclamation)
		#EndIf
	#EndMacro

#EndIf