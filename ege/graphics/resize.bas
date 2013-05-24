'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_BITMAP_RESIZE_BAS__
#Define __EGE_BITMAP_RESIZE_BAS__

	
	Sub Bitmap.Resize(W As Integer, H As Integer, method As ResizeMethod = fbScale)
		
		Assert( IsValidPtr( This.imgHandle ) )
				
		If W = This.iW And H = This.iH Then Exit Sub 
		
		Dim As Bitmap bmpTemp
		Dim As Double factorX, factorY
		
		bmpTemp.Copy This
		
		This.Create W, H, Color.Transparent, bmpTemp.BPP * 8
		
		
		Dim As Any Pointer destPixels = This.imgHandle + SizeOf(FB.IMAGE)
		Dim As Any Pointer srcPixels = bmpTemp.Handle + SizeOf(FB.IMAGE)
		
		If (method And fbScaleX) <> 0 And (method And fbScaleY) <> 0 Then
			
			factorX = bmpTemp.Width / W
			factorY = bmpTemp.Height / H
			
			If method And fbBilinear Then
				
				Dim As Double fracX, fracY, mX, mY
				Dim As Integer ceilX, ceilY, floorX, floorY
				Dim As Color.RGBTriple c1, c2, c3, c4
				Dim As UByte red, green, blue, b1, b2
				
				For X As Integer = 0 To W - 1
					For Y As Integer = 0 To H - 1
						
						floorX = Int(X * factorX)
						ceilX = floorX + 1
						If ceilX > W Then ceilX = floorX
						fracX = X * factorX - floorX
						mX = 1.0 - fracX
						
						floorY = Int(Y * factorY)
						ceilY = floorY + 1
						If ceilY > H Then ceilY = floorY
						fracY = Y * factorY - floorY
						mY = 1.0 - fracY
						
						c1.Value = *Cast(UInteger Pointer, srcPixels + floorY * bmpTemp.Pitch + floorX * bmpTemp.BPP)
						c2.Value = *Cast(UInteger Pointer, srcPixels + floorY * bmpTemp.Pitch + ceilX * bmpTemp.BPP)
						c3.Value = *Cast(UInteger Pointer, srcPixels + ceilY * bmpTemp.Pitch + floorX * bmpTemp.BPP)
						c4.Value = *Cast(UInteger Pointer, srcPixels + ceilY * bmpTemp.Pitch + ceilX * bmpTemp.BPP)
						
						b1 = mX * c1.Alpha + fracX * c2.Alpha
						b2 = mX * c3.Alpha + fracX * c4.Alpha
						
						*(Cast(UByte Pointer, destPixels + Y * This.iPitch + X * This.iBPP) + 3) = mY * b1 + fracY * b2		
										
						b1 = mX * c1.Red + fracX * c2.Red
						b2 = mX * c3.Red + fracX * c4.Red
						
						*(Cast(UByte Pointer, destPixels + Y * This.iPitch + X * This.iBPP) + 2) = mY * b1 + fracY * b2
						
						b1 = mX * c1.Green + fracX * c2.Green
						b2 = mX * c3.Green + fracX * c4.Green
						
						*(Cast(UByte Pointer, destPixels + Y * This.iPitch + X * This.iBPP) + 1) = mY * b1 + fracY * b2
						
						b1 = mX * c1.Blue + fracX * c2.Blue
						b2 = mX * c3.Blue + fracX * c4.Blue
						
						*(Cast(UByte Pointer, destPixels + Y * This.iPitch + X * This.iBPP) + 0) = mY * b1 + fracY * b2   
						
					Next 
				Next 
				
								
			Else
				
				For X As Integer = 0 To W - 1
					For Y As Integer = 0 To H - 1
						
						*Cast(UInteger Pointer, destPixels + Y * This.iPitch + X * This.iBPP) = _ 
						*Cast(UInteger Pointer, srcPixels + CInt(Y * factorY) * bmpTemp.Pitch + CInt(X * factorX) * bmpTemp.BPP)
						
					Next
				Next
				
			EndIf
			
		EndIf
		
		' TODO: implement tiling and scale+tile combined resize modes
		
		bmpTemp.Destroy
		
	End Sub
	
#EndIf