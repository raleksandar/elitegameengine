'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_UI_LABEL_BAS__
#Define __EGE_UI_LABEL_BAS__

	Property Label.X As Integer
		Return This.mRect.X
	End Property
	
	Property Label.X(newValue As Integer)
		This.mRect.X = newValue
	End Property
	
	
	Property Label.Y As Integer
		Return This.mRect.Y
	End Property
	
	Property Label.Y(newValue As Integer)
		This.mRect.Y = newValue
	End Property
	
	
	Property Label.W As Integer
		Return This.mRect.W
	End Property
	
	Property Label.W(newValue As Integer)
		This.mRect.W = newValue
		This.RecreateBuffer
	End Property
	
	
	Property Label.H As Integer
		Return This.mRect.H
	End Property
	
	Property Label.H(newValue As Integer)
		This.mRect.H = newValue
		This.RecreateBuffer
	End Property
	
	
	Sub Label.Size(newW As Integer, newH As Integer)
		This.mRect.W = newW
		This.mRect.H = newH
		This.RecreateBuffer
	End Sub
	
	
	Property Label.Font As Graphics.Font Pointer
		Return VarPtr(This.mFont)
	End Property
	
	Property Label.Font(newValue As Graphics.Font)
		This.mFont = newValue
		This.RepaintBuffer
	End Property

	
	Property Label.Align As TextAlignment
		Return This.mAlign
	End Property
	
	Property Label.Align(newValue As TextAlignment)
		This.mAlign = newValue
		This.RepaintBuffer
	End Property
	
	
	Property Label.Text As String
		Return This.mText
	End Property
	
	Property Label.Text(newValue As String)
		This.mText = newValue
		This.RepaintBuffer
	End Property
	
	Sub Label.DrawTo(dest As Bitmap, srcX As Integer = 0, srcY As Integer = 0, srcW As Integer = 0, srcH As Integer = 0, method As RasterOp = fbAlpha, blender As CustomBlenderProc = 0, param As Any Pointer = 0)
		Assert( IsValidPtr( This.mBuffer.Handle ) )
		This.mBuffer.DrawTo dest, This.mRect.X, This.mRect.Y, srcX, srcY, srcW, srcH, method, blender, param	
	End Sub
	
	Sub Label.DrawTo(dest As Any Pointer, srcX As Integer = 0, srcY As Integer = 0, srcW As Integer = 0, srcH As Integer = 0, method As RasterOp = fbAlpha, blender As CustomBlenderProc = 0, param As Any Pointer = 0)
		Assert( IsValidPtr( This.mBuffer.Handle ) )
		This.mBuffer.DrawTo dest, This.mRect.X, This.mRect.Y, srcX, srcY, srcW, srcH, method, blender, param	
	End Sub
	
	Destructor Label
		This.mFont.Destroy
		This.mBuffer.Destroy
	End Destructor
	
	Sub Label.RecreateBuffer
				
		This.mBuffer.Create mRect.W, mRect.H, Color.Transparent
		
		This.RepaintBuffer
				
	End Sub
	
	
	Sub Label.RepaintBuffer

		Assert( IsValidPtr( This.mFont.image.Handle ) )
		
		If IsValidPtr( This.mBuffer.Handle ) And Len(This.mText) > 0 Then
			
			Dim As String lines()
			Dim As Integer textW, textH, dstX, dstY
			
			textH = This.mFont.TextHeight(This.mText)
			
			Split This.mText, !"\n", lines()
			
			If This.mAlign And AlignBottom Then
				dstY = This.mRect.H - textH
			ElseIf This.mAlign And AlignMiddle Then
				dstY = (This.mRect.H - textH) / 2
			Else
				dstY = 0
			EndIf
			
			For i As Integer = LBound(lines) To UBound(lines)
				
				textW = This.mFont.TextWidth(lines(i))
				
				If This.mAlign And AlignRight Then
					dstX = This.mRect.W - textW
				ElseIf This.mAlign And AlignCenter Then
					dstX = (This.mRect.W - textW) / 2
				Else
					dstX = 0
				EndIf
				
				This.mFont.DrawTo lines(i), This.mBuffer.Handle, dstX, dstY, , , , , fbPSet
				
				dstY += This.mFont.LineHeight + This.mFont.LineSpacing
				
			Next
			
		EndIf
		
		Engine.Repaint
		
	End Sub
	

#EndIf