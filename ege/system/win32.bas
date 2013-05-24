'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_SYSTEM_WIN32_BAS__
#Define __EGE_SYSTEM_WIN32_BAS__
	
	Extern "Windows"

		Declare Function _MessageBox Lib "user32.dll" Alias "MessageBoxA" (ByVal hwnd As Integer, ByVal lpText As ZString ptr, ByVal lpCaption As ZString ptr, ByVal wType As Integer) As Integer
		Declare Function _TerminateProcess Lib "kernel32.dll" Alias "TerminateProcess" (ByVal hProcess As Integer, ByVal uExitCode As Integer) As Integer
		Declare Function _GetCurrentProcess Lib "kernel32.dll" Alias "GetCurrentProcess" () As Integer
		Declare Function _SetClassLong Lib "user32.dll" Alias "SetClassLongA" (ByVal hwnd As Integer, ByVal nIndex As Integer, ByVal dwNewLong As Integer) As Integer
		Declare Function _LoadIcon Lib "user32.dll" Alias "LoadIconA" (ByVal hInstance As Integer, ByVal lpIconName As ZString Ptr) As Integer
		Declare Function _GetModuleHandle Lib "kernel32.dll" Alias "GetModuleHandleA" (ByVal lpModuleName As ZString Ptr) As Integer     

	End Extern
	
	
	Function MsgBox(Text As String, Title As String = "Message", Style As MsgBoxStyle = fbOkOnly) As Integer
		
		Dim As Integer hwnd
		
		ScreenControl FB.GET_WINDOW_HANDLE, hwnd
		
		Return _MessageBox(hwnd, Text, Title, Style)
		
	End Function
	
	Sub Terminate(code As Integer = 0)
		
		_TerminateProcess _GetCurrentProcess, code
		
	End Sub
	
	Sub SetWindowIcon(resId As Integer = 1)
		
		Const GCL_HICON	As Integer = -14
		
		Dim As Integer hwnd
		
		ScreenControl FB.GET_WINDOW_HANDLE, hwnd
		
		_SetClassLong hwnd, GCL_HICON, _LoadIcon(_getModuleHandle(0), CPtr(Zstring Ptr, resId))
		
	End Sub
	
	#Define _EGE_SYSTEM_SYSMODAL_BOX_ &h1000
	#Define _NEW_LINE_ !"\r\n"


#EndIf
