'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteResource Compiler source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __ERC_BITMAPFONT__
#Define __ERC_BITMAPFONT__
	
	#Include "dynarray.bi"
	#include "file.bi"

Namespace BitmapFont
	
	Enum Boolean
		False
		True = Not False
	End Enum


	Type FontInfo Field = 1
		WChar			As Integer
		LineHeight		As UInteger
		LineSpacing		As UInteger
		LetterSpacing	As UInteger
		PaddingTop		As Integer
		PaddingLeft		As Integer
		PaddingRight	As Integer
		PaddingBottom	As Integer
		SpaceWidth		As Integer
		TabWidth		As Integer
		TabSize			As Integer
	End Type
	
	Type Char Field = 1
		Code		As Integer
		X			As Integer
		Y			As Integer
		W			As Integer
		H			As Integer
		OffsetX		As Integer
		OffsetY		As Integer
	End Type
	
	DefineDynamicArrayType( Char )
	
	Type KerningPair Field = 1
		FirstChar	As Integer
		SecondChar	As Integer
		KernBy		As Integer
	End Type 
	
	DefineDynamicArrayType( KerningPair )
	
	#Macro NumericValue(_val_)
		If IIf(Left(LCase(_val_), 2) = "&h", "&h" + LCase(Hex(valInt(_val_))) <> LCase(_val_), _
			IIf(Left(LCase(_val_), 2) = "&o", "&o" + Oct(valInt(_val_)) <> LCase(_val_), _
				IIf(Left(LCase(_val_), 2) = "&b", "&b" + Bin(valInt(_val_)) <> LCase(_val_), _
					Str(valInt(_val_)) <> _val_))) Then
			Print "Error: Expected numeric value but '"; _val_ ;"' found at line "; Str(iLineNumber)
			Return 1
		EndIf
	#EndMacro
	
	
	Declare Function ParseSection(sToken() As String, iLineNumber As Integer) As Integer
	
	Declare Function ParseFont(sToken() As String, iLineNumber As Integer) As Integer
	Declare Function ParseCharacters(sToken() As String, iLineNumber As Integer) As Integer
	Declare Function ParseKerning(sToken() As String, iLineNumber As Integer) As Integer
	
	Declare Function GetSection(section As String) As Integer
	
	Declare Function CompileResource(inputFile As String, outputFile As String) As Integer
	
	Declare Function CharCompare(ByRef a As Char, ByRef b As Char) As Integer
	Declare Function KerningPairCompare(ByRef a As KerningPair, ByRef b As KerningPair) As Integer
	
	Dim Shared As Integer curSection = -1
	Dim Shared As ResType ResourceType
	
	Dim Shared As FontInfo 			font
	Dim Shared As String			fontBitmap
	Dim Shared As CharArray			characters
	Dim Shared As KerningPairArray	kerning
	
	Sub Module Constructor
		
		ResourceType.Name = "BitmapFont"
		ResourceType.Extension = "ebf"
		ResourceType.GetSection = ProcPtr(GetSection)
		ResourceType.Parse = ProcPtr(ParseSection)
		ResourceType.Compile = ProcPtr(CompileResource)
		
		RegisterResourceType BitmapFont.ResourceType
		
	End Sub
	
	
	Function GetSection(section As String) As Integer
			
		Select Case LCase(section)
			Case "font":		curSection = 0
			Case "characters":	curSection = 1
			Case "kerning":		curSection = 2
		End Select
		
		Return curSection
		
	End Function
	
	Function ParseSection(sToken() As String, iLineNumber As Integer) As Integer
		
		Select Case curSection
			Case 0: Return ParseFont(sToken(), iLineNumber)
			Case 1: Return ParseCharacters(sToken(), iLineNumber)
			Case 2: Return ParseKerning(sToken(), iLineNumber)
		End Select
		
	End Function
	
	
	' Property = Value
	Function ParseFont(sToken() As String, iLineNumber As Integer) As Integer
		
		If UBound(sToken) < 2 Then
			Print "Error: Syntax error at line "; Str(iLineNumber)
			Return 0 
		EndIf
		
		If sToken(1) <> "=" Then
			Print "Error: Syntax error at line "; Str(iLineNumber)
			Return 0 
		EndIf
		
		Dim value As String = Join(sToken(), " ", 2)
		
		Select Case LCase(sToken(0))
			Case "bitmap": fontBitmap = value
			Case "wchar": font.WChar = ValInt(value) <> 0
			Case "lineheight": font.LineHeight = valInt(value)
			Case "linespacing": font.LineSpacing = ValInt(value)
			Case "letterspacing": font.LetterSpacing = ValInt(value)
			Case "paddingtop": font.PaddingTop = ValInt(value)
			Case "paddingleft": font.PaddingLeft = ValInt(value)
			Case "paddingright": font.PaddingRight = ValInt(value)
			Case "paddingbottom": font.PaddingBottom = ValInt(value)
			Case "spacewidth": font.SpaceWidth = ValInt(value)
			Case "tabwidth": font.TabWidth = ValInt(value)
			Case "tabsize": font.TabSize = ValInt(value)
			Case Else
				Print "Error: Unknown property '"; sToken(0); "' at line "; Str(iLineNumber)
				Return 0
		End Select
		
		Return 1
		
	End Function
	
	' Char Character X Y W H [OffsetX] [OffsetY]
	' CharCode Code  X Y W H [OffsetX] [OffsetY]
	Function ParseCharacters(sToken() As String, iLineNumber As Integer) As Integer
		
		Dim As Boolean charcode = False
		Dim As Char charinfo
		
		Select Case LCase(sToken(0))
			Case "char"
				charcode = False
			Case "charcode"
				charcode = True
			Case Else
				Print "Error: 'Char' or 'CharCode' expected, but '"; sToken(0); "' found at line "; Str(iLineNumber)
				Return 0
		End Select
		
		If UBound(sToken) < 5 Or UBound(sToken) > 7 Then
			Print "Error: Argument count mismatch at line "; Str(iLineNumber)
			Return 0
		EndIf
		
		If charcode Then
			NumericValue(sToken(1))
			charinfo.Code = ValInt(sToken(1))
		Else
			If Len(sToken(1)) <> 1 Then
				Print "Error: Expected one character, but '"; sToken(1); "' found at line "; Str(iLineNumber)
				Return 1
			EndIf
			charinfo.Code = Asc(sToken(1))
		EndIf
		
		NumericValue(sToken(2)) :  charinfo.X = ValInt(sToken(2))
		NumericValue(sToken(3)) :  charinfo.Y = ValInt(sToken(3))
		NumericValue(sToken(4)) :  charinfo.W = ValInt(sToken(4))
		NumericValue(sToken(5)) :  charinfo.H = ValInt(sToken(5))
		
		If UBound(sToken) > 5 Then
			NumericValue(sToken(6)) :  charinfo.OffsetX = ValInt(sToken(6))
			If UBound(sToken) = 7 Then
				NumericValue(sToken(7)) :  charinfo.OffsetY = ValInt(sToken(7))
			EndIf			
		EndIf
		
		characters.Add charinfo
		
		Return 1
		
	End Function
	
	
	' Char <char> Char <char> KernBy <int>
	' Char <char> CharCode <code> KernBy <int>
	' CharCode <code> Char <char> KernBy <int>
	' CharCode <code> CharCode <code> KernBy <int>
	Function ParseKerning(sToken() As String, iLineNumber As Integer) As Integer
		
		Dim As KerningPair pair
		
		If UBound(sToken) <> 5 Then
			Print "Error: Argument count mismatch at line "; Str(iLineNumber)
			Return 0
		EndIf
		
		Select Case LCase(sToken(0))
			Case "char"
				If Len(sToken(1)) <> 1 Then
					Print "Error: Expected one character, but '"; sToken(1); "' found at line "; Str(iLineNumber)
					Return 0
				Else
					pair.FirstChar = Asc(sToken(1))
				EndIf
			Case "charcode"
				NumericValue(sToken(1))
				pair.FirstChar = ValInt(sToken(1))
			Case Else
				Print "Error: 'Char' or 'CharCode' expected, but '"; sToken(0); "' found at line "; Str(iLineNumber)
				Return 0
		End Select
		
		Select Case LCase(sToken(2))
			Case "char"
				If Len(sToken(3)) <> 1 Then
					Print "Error: Expected one character, but '"; sToken(3); "' found at line "; Str(iLineNumber)
					Return 0
				Else
					pair.SecondChar = Asc(sToken(3))
				EndIf
			Case "charcode"
				NumericValue(sToken(3))
				pair.SecondChar = ValInt(sToken(3))
			Case Else
				Print "Error: 'Char' or 'CharCode' expected, but '"; sToken(2); "' found at line "; Str(iLineNumber)
				Return 0
		End Select
		
		If LCase(sToken(4)) <> "kernby" Then
			Print "Error: 'KernBy' expected, but '"; sToken(4); "' found at line "; Str(iLineNumber)
			Return 0
		EndIf
		
		NumericValue(sToken(5)) :  pair.KernBy = ValInt(sToken(5))
		
		kerning.Add pair
		
		Return 1
		
	End Function
	
	Function CompileResource(inputFile As String, outputFile As String) As Integer
		
		Dim As Integer fn = FreeFile
		
		If Not IsAbs(fontBitmap) Then
			fontBitmap = DirName(inputFile) + fontBitmap
		EndIf
		
		If Len(fontBitmap) = 0 Then
			Print "Error: Bitmap parameter not found in ""Font"" section"
			Return 0
		ElseIf Not FileExists(fontBitmap) Then
			Print "Error: Bitmap file '"; fontBitmap; "' cannot be found"
			Return 0
		EndIf
		
		Dim As Integer bufferLen = FileLen(fontBitmap)
		Dim As UByte buffer()
		
		ReDim buffer(0 To bufferLen - 1)
		
		If Open(fontBitmap For Binary Access Read Lock Write As fn) = 0 Then
			Get #fn, , buffer()
			Close #fn
		Else
			Print "Error: failed to open '"; fontBitmap; "' for reading"
			Return 0
		EndIf
		
		Dim pair As KerningPair
		
		pair.FirstChar = 32
		pair.SecondChar = 32
		pair.KernBy = -2
		kerning.Add pair
		
		characters.Sort ProcPtr(CharCompare)
		kerning.Sort ProcPtr(KerningPairCompare)
		
		Kill outputFile
		
		fn = FreeFile
		If Open(outputFile For Binary Access Write Lock Write As fn) = 0 Then
			
			Dim signature As String * 4
			
			signature = !"EBF\0" 
			
			Put #fn, , signature										' EBF format signature
			Put #fn, , MakeVersion(1, 0)								' format version 1.0
			Put #fn, , font												' font info
			Put #fn, , bufferLen										' png data length
			Put #fn, , buffer()											' png data
			Put #fn, , characters.ItemCount								' charinfo array length
			
			If characters.ItemCount > 0 Then
				Put #fn, , characters.PeekAt(0)[0], characters.ItemCount' charinfo array
			EndIf
			
			Put #fn, , kerning.ItemCount								' kerninginfo array length
			
			If kerning.ItemCount > 0 Then
				Put #fn, , kerning.PeekAt(0)[0], kerning.ItemCount	    ' kerninginfo array
			EndIf
			
		Else
			
			Print "Error: Failed to open output file ("; outputFile ;")"
			End CODE_CANT_OPEN
			
		EndIf
		
		Return 1
		
	End Function
	
	Function CharCompare(ByRef a As Char, ByRef b As Char) As Integer
		Return a.Code < b.Code
	End Function
	
	Function KerningPairCompare(ByRef a As KerningPair, ByRef b As KerningPair) As Integer
		Return a.FirstChar < b.FirstChar
	End Function
	
End Namespace

#EndIf