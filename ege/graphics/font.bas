'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_FONT_BAS__
#Define __EGE_FONT_BAS__
	
	#Define MakeVersion(major,minor) CInt(CUShort(major) Or (CUInt(CUShort(minor)) Shl 16))
	
	' returns count of SubStr in Source
	Function SubStrCount(ByVal Source As String, ByVal SubStr As String) As UInteger
		
		Dim As Integer count = 0, position = InStr(1, Source, SubStr)
		
		While position > 0
			
			count += 1
			
			position = InStr(position + Len(SubStr), Source, SubStr)
			
		Wend
		
		Return count
		
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
	
	Function Font.LoadFromFile(Filename As String) As Elite.Boolean
		
		Dim As Integer fn = FreeFile
		
		Dim As Integer		size
		Dim As UByte		buffer()
		
		If Open(Filename For Binary Access Read Lock Write As #fn) = 0 Then
			
			size = Lof(fn)
			ReDim buffer(0 To size - 1)
			
			If Get(#fn, , buffer()) = 0 Then
				
				Return This.LoadFromMemory(VarPtr(buffer(0)), size)		
				
			EndIf
			
		EndIf
		
		Return Elite.False
		
	End Function
	
	
	Function Font.LoadFromMemory(mem As Any Pointer, size As Integer) As Elite.Boolean
		
		Dim As String * 4 signature
		Dim As Integer pngsize
		
		This.Destroy
		
		If IsValidPtr(mem) And  size > 92 Then	' minimum size allowed (min 1b png data, min 1 char and no kerning info) 
			
			signature = *Cast(ZString Pointer, mem)
			
			If signature = !"EBF\0" Then
					
				If *Cast(Integer Pointer, mem + 4) = MakeVersion(1, 0) Then
					
					This.WChar = *Cast(Integer Pointer, mem + 8)
					This.LineHeight = *Cast(UInteger Pointer, mem + 12)
					This.LineSpacing = *Cast(UInteger Pointer, mem + 16)
					This.LetterSpacing = *Cast(UInteger Pointer, mem + 20)
					This.PaddingTop = *Cast(Integer Pointer, mem + 24)
					This.PaddingLeft = *Cast(Integer Pointer, mem + 28)
					This.PaddingRight = *Cast(Integer Pointer, mem + 32)
					This.PaddingBottom = *Cast(Integer Pointer, mem + 36)
					This.SpaceWidth = *Cast(Integer Pointer, mem + 40)
					This.TabWidth = *Cast(Integer Pointer, mem + 44)
					This.TabSize = *Cast(Integer Pointer, mem + 48)
					
					pngsize = *Cast(Integer Pointer, mem + 52)
					This.image.LoadFromMemory(mem + 56, pngsize)
					
					This.charCount = *Cast(Integer Pointer, mem + pngsize + 56)
					If This.charCount > 0 Then
						This.char = New _Char[This.charCount]
						For i As Integer = 0 To This.charCount - 1
							This.char[i] = *Cast(_Char Pointer, mem + pngsize + 60 + i * SizeOf(_Char))
						Next
					EndIf
					
					This.kerningCount = *Cast(Integer Pointer, mem + pngsize + 60 + This.charCount * SizeOf(_Char))
					If This.kerningCount > 0 Then
						This.kerning = New _KerningPair[This.kerningCount]
						For i As Integer = 0 To This.kerningCount - 1
							This.kerning[i] = *Cast(_KerningPair Pointer, mem + pngsize + 64 + This.charCount * SizeOf(_Char) + i * SizeOf(_KerningPair))
						Next
					EndIf
					
					Assert( This.charCount > 0 )
					Assert( This.kerningCount > 0 ) ' there must be at least one kerning pair ( ERC will always put this pair: 32 32 -2 )
					
					Return Elite.True
					
				EndIf
				
			EndIf
			
		EndIf
		
		Return Elite.False
		
	End Function
	
	
	Sub Font.DrawTo(text As String, dest As Any Pointer, dstX As Integer = 0, dstY As Integer = 0, srcX As Integer = 0, srcY As Integer = 0, W As Integer = 0, H As Integer = 0, method As RasterOp = fbAlpha, blender As CustomBlenderProc = 0, param As Any Pointer = 0)
		
		Assert( IsValidPtr( This.image.Handle ) )
		Assert( This.charCount > 0 )
		Assert( This.kerningCount > 0 )
		
		Dim As Integer x, y = dstY + This.PaddingTop, c, k, char, prev
		Dim As String lines()
		
		Split text, !"\n", lines()
		
		For l As Integer = LBound(lines) To UBound(lines)
			
			x = This.PaddingLeft + dstX
			
			For i As Integer = 1 To Len(lines(l))
				
				char = Asc(Mid(lines(l), i, 1))
				
				c = This.GetChar(char)
				
				If c > -1 Then
					
					If i > 1 Then
						
						k = This.GetKerning(prev, char)
						
						If k > -1 Then x += This.kerning[k].KernBy
						
					EndIf
					
					This.image.DrawTo dest, x + This.char[c].OffsetX, y + This.char[c].OffsetY, _
									  This.char[c].X, This.char[c].Y, This.char[c].W, This.char[c].H, _
									  method, blender, param
					
					x += This.char[c].OffsetX + This.char[c].W + This.LetterSpacing
					
				ElseIf char = 32 Then	' space
					
					x += This.SpaceWidth + This.LetterSpacing
				
				ElseIf char = 9 Then	' tab
					
					x += (This.TabSize - (i Mod This.TabSize)) * This.TabWidth
					
				EndIf
				
				prev = char
				
			Next
			
			y += This.LineHeight + This.LineSpacing
			
		Next
				
	End Sub
	
	
	Sub Font.DrawTo(text As String, dest As Bitmap, dstX As Integer = 0, dstY As Integer = 0, srcX As Integer = 0, srcY As Integer = 0, W As Integer = 0, H As Integer = 0, method As RasterOp = fbAlpha, blender As CustomBlenderProc = 0, param As Any Pointer = 0)
		
		This.DrawTo text, dest.Handle, dstX, dstY, srcX, srcY, W, H, method, blender, param
		
	End Sub
	
	
	Function Font.TextWidth(text As String) As Integer
		
		Assert( IsValidPtr( This.image.Handle ) )
		Assert( This.charCount > 0 )
		Assert( This.kerningCount > 0 )
		
		Dim As Integer w, maxw = 0, c, char, prev
		Dim As String lines()
		
		Split text, !"\n", lines()
		
		For l As Integer = LBound(lines) To UBound(lines)
			
			w = 0
			
			For i As Integer = 1 To Len(lines(l))
				
				char = Asc(Mid(lines(l), i, 1))
				
				c = This.GetChar(char)
				
				If c > -1 Then
					
					w += This.char[c].W + This.LetterSpacing
					
				ElseIf char = 32 Then	' space
					
					w += This.SpaceWidth + This.LetterSpacing
				
				ElseIf char = 9 Then	' tab
					
					w += (This.TabSize - (i Mod This.TabSize)) * This.TabWidth
					
				EndIf
				
				If i > 1 Then
					
					c = This.GetKerning(prev, char)
					
					If c > -1 Then w += This.kerning[c].KernBy 
					
				EndIf
				
				prev = char
				
			Next
			
			If w > maxw Then maxw = w
			
		Next
		
		Return maxw + This.PaddingLeft + This.PaddingRight - This.LetterSpacing
		
	End Function
	
	
	Function Font.TextHeight(text As String) As Integer
		
		Assert( This.image.Handle )
		Assert( This.charCount > 0 )
		Assert( This.kerningCount > 0 )
		
		Dim As Integer lines = SubStrCount(text, !"\n")
		
		Return lines * This.LineHeight + (lines - 1) * This.LineSpacing + This.PaddingTop + This.PaddingBottom
			
	End Function
	
	
	Sub Font.Destroy
		
		This.image.Destroy
		NullDeleteArray( This.char )
		NullDeleteArray( This.kerning )
		
	End Sub
	
	
	Function Font.GetKerning(first As Integer, second As Integer) As Integer
		
		If first > This.kerning[0].FirstChar And first < This.kerning[This.kerningCount - 1].FirstChar Then
			
			For i As Integer = 0 To This.kerningCount - 1
				
				If first = This.kerning[i].FirstChar Then
					
					If second = This.kerning[i].SecondChar Then Return This.kerning[i].KernBy 
					
				ElseIf first < This.kerning[i].FirstChar Then
					
					Exit For
					
				EndIf
				
			Next
				
		EndIf
		
		Return 0
		
	End Function
	
	
	Function Font.GetChar(code As Integer) As Integer
		
		If code > This.char[0].Code And code < This.char[This.charCount - 1].Code Then
			
			For i As Integer = 0 To This.charCount - 1
				
				If code = This.char[i].Code Then
					
					Return i
					
				ElseIf code < This.char[i].Code Then
					
					Return -1
					
				EndIf
				
			Next
				
		EndIf
		
		Return -1
		
	End Function
	
	
	Constructor Font(Filename As String = "")
		
		If Len(Filename) <> 0 Then
			
			This.LoadFromFile Filename
			
		EndIf
		
	End Constructor
	
	
	Constructor Font(mem As Any Pointer, size As Integer)
		
		Assert( IsValidPtr( mem ) )
		Assert( size > 0 )
		
		This.LoadFromMemory mem, size
		
	End Constructor
	
	
	Destructor Font
		
		This.Destroy
	
	End Destructor
	
	
	#Undef MakeVersion
	
#EndIf