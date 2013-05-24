'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteResource Compiler source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __ERC_FUNCTIONS__
#Define __ERC_FUNCTIONS__


Declare Function ReplaceExt(Filename As String, Ext As String) As String
Declare Function Replace(Source As String, Find As String, ReplaceWith As String, textCompare As Byte = 0) As String
Declare Function Split(ByVal Source As String, ByVal Delimiter As String,  Result() As String) As UInteger
Declare Function Join(Source() As String, Delimiter As String, Start As Integer = -1) As String
Declare Function DirName(Filename As String) As String
Declare Function IsAbs(Filename As String) As Integer



' replaces file extension in Filename
Function ReplaceExt(Filename As String, Ext As String) As String

	Dim iPos As Integer = 0
	Dim c As String * 1

	For i As Integer = Len(Filename) To 1 Step -1

		c = Mid(Filename, i, 1)

		If c = "." Then
			iPos = i
			Exit For
		ElseIf c = "/" Or c = "\" Then
			Exit For
		EndIf

	Next

	If iPos = 0 Then
		Filename += "."
		iPos = Len(Filename)
	EndIf

	Return Left(Filename, iPos) + Ext

End Function

' replaces one string with another
Function Replace(Source As String, Find As String, ReplaceWith As String, textCompare As Byte = 0) As String

	Dim iPos As Integer
	Dim ret As String

	ret = Source
	iPos = -Len(ReplaceWith) + 1

	Do
		If textCompare = 0 Then
			iPos = InStr(iPos + Len(ReplaceWith), ret, Find)
		Else
			iPos = InStr(iPos + Len(ReplaceWith), LCase(ret), LCase(Find))
		EndIf

		If iPos = 0 Then Exit Do

		ret = Left(ret, iPos - 1) + ReplaceWith + Right(ret, Len(ret) - iPos - Len(Find) + 1)

	Loop

	Return ret

End Function

' splits Source by Delimiter
Function Split(ByVal Source As String, ByVal Delimiter As String, Result() As String) As UInteger
	
	Dim As Integer position = InStr(Source, Delimiter)
	Dim As Integer count = -1, size = Len(Source) / 2
	
	ReDim Result(0 To size)
	
	While position > 0
		
		count += 1
		
		If count > size Then
			
			size *= 1.1
			
			ReDim Preserve Result(0 To size)
			
		EndIf
		
		Result(count) = Left(Source, position - 1)
		
		Source = Mid(Source, position + Len(Delimiter))
		
		position = InStr(Source, Delimiter)
		
	Wend
	
	If Len(source) > 0 Then

		count += 1
		
		If count > size Then
			
			size += 1
			
			ReDim Preserve Result(0 To size)
			
		EndIf
		
		Result(count) = Source	
		
	EndIf
		
	If size > count Then
		
		ReDim Preserve Result(0 To count)
		
	EndIf
	
	Return count + 1
	
End Function

' joins Source using Delimiter
Function Join(Source() As String, Delimiter As String, Start As Integer = -1) As String
	
	Dim ret As String
	
	If Start = -1 Then Start = LBound(Source)
	
	For i As Integer = Start To UBound(Source)
		ret &= Source(i)
		If i < UBound(Source) Then ret &= Delimiter
	Next
	
	Return ret
	
End Function

' returns directory part of filename with trailing slash
Function DirName(Filename As String) As String
	
	#Ifdef __FB_WIN32__
		#Define PATH_SEPARATOR "\"
		#Define PATH_SEPARATOR_ALT "/"
	#Else
		#Define PATH_SEPARATOR "/"
		#Define PATH_SEPARATOR_ALT ""
	#EndIf
	
	Dim As Integer iPos = Len(Filename)
	
	For i As Integer = Len(Filename) To 1 Step -1
		If Mid(Filename, i, 1) = PATH_SEPARATOR Or Mid(Filename, i, 1) = PATH_SEPARATOR_ALT Then
			iPos = i - 1
			Exit For
		EndIf
	Next
	
	Return Left(Filename, iPos) + PATH_SEPARATOR
	
	#Undef PATH_SEPARATOR
	#Undef PATH_SEPARATOR_ALT
	
End Function

' returns -1 if filename is absolute (0 otherwise)
Function IsAbs(Filename As String) As Integer
	Return IIf(Len(Filename) > 3, IIf(Mid(Replace(Filename, "\", "/"), 2, 2) = ":/", -1, 0), 0) 
End Function

#EndIf