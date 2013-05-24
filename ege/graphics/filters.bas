'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_FILTERS_BAS__
#Define __EGE_FILTERS_BAS__
	
	'
	' 	Most of these filters are result of reading 
	'	Christian Graus' articles on The Code Project website
	'
	'
	
	
	' some useful macros for internal use only
	#Define AlphaPixel 			(Cast(UByte Pointer, pixels + y * Pitch + x * BPP) + 3)
	#Define RedPixel 			(Cast(UByte Pointer, pixels + y * Pitch + x * BPP) + 2)
	#Define GreenPixel 			(Cast(UByte Pointer, pixels + y * Pitch + x * BPP) + 1)
	#Define BluePixel 			(Cast(UByte Pointer, pixels + y * Pitch + x * BPP) + 0)
	#Define ARGBPixel			(Cast(UInteger Pointer, pixels + y * Pitch + x * BPP))
	#Define RedPixelXY(_X, _Y)	(Cast(UByte Pointer, pixels + (_Y) * Pitch + (_X) * BPP) + 2)
	#Define GreenPixelXY(_X, _Y)(Cast(UByte Pointer, pixels + (_Y) * Pitch + (_X) * BPP) + 1)
	#Define BluePixelXY(_X, _Y)	(Cast(UByte Pointer, pixels + (_Y) * Pitch + (_X) * BPP) + 0)
	
	#Define ValueOf(_ptr_)	*(_ptr_)
	
	#Macro SetPixel(_pixel_, _value_)
		If (_value_) < 0 Then
			ValueOf(_pixel_) = 0
		ElseIf (_value_) > 255 Then
			ValueOf(_pixel_) = 255
		Else
			ValueOf(_pixel_) = _value_
		EndIf
	#EndMacro
	
	
	' Invert filter
	Sub Invert(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Any Pointer)
		
		For x As Integer = 0 To W - 1
			For y As Integer = 0 To H - 1
				
				ValueOf(RedPixel) 	= 255 - ValueOf(RedPixel)
				ValueOf(GreenPixel)	= 255 - ValueOf(GreenPixel)
				ValueOf(BluePixel) 	= 255 - ValueOf(BluePixel)

			Next
		Next		
		
	End Sub
	
	' Grayscale filter
	Sub Grayscale(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Any Pointer)
		
		Dim As Byte value 
		
		For x As Integer = 0 To W - 1
			For y As Integer = 0 To H - 1
				
				value = ValueOf(RedPixel) 	* 0.299 + _
						ValueOf(GreenPixel) * 0.587 + _
						ValueOf(BluePixel)	* 0.114
				
				ValueOf(RedPixel) 	= value
				ValueOf(GreenPixel)	= value
				ValueOf(BluePixel) 	= value
				
			Next
		Next			
		
	End Sub
	
	' Brightness filter
	Sub Brightness(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Integer Pointer)
		
		Dim As Integer iBrightness = Math.Constrain(ValueOf(param), -100, +100)
		
		For x As Integer = 0 To W - 1
			For y As Integer = 0 To H - 1
				
				SetPixel( RedPixel,		CInt(ValueOf(RedPixel)) + iBrightness 	)
				SetPixel( GreenPixel,	CInt(ValueOf(GreenPixel)) + iBrightness )
				SetPixel( BluePixel,	CInt(ValueOf(BluePixel)) + iBrightness	)
				
			Next
		Next
		
	End Sub
	
	' Contrast filter
	Sub Contrast(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Integer Pointer)
		
		Dim As Double sContrast = ((100 + Math.Constrain(ValueOf(param), -100, 100)) / 100) ^ 2
		
		#Define func(pixel) ((((pixel) / 255) - 0.5) * sContrast + 0.5) * 255
		
		For x As Integer = 0 To W - 1
			For y As Integer = 0 To H - 1
				
				SetPixel( RedPixel, 	func(ValueOf(RedPixel))		)
				SetPixel( GreenPixel, 	func(ValueOf(GreenPixel))	)
				SetPixel( BluePixel, 	func(ValueOf(BluePixel)) 	)
				
			Next
		Next
		
		#Undef func
		
	End Sub
	
	' ColorOffset filter
	Sub ColorOffset(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Color.RGBTriple Pointer)
		
		For x As Integer = 0 To W - 1
			For y As Integer = 0 To H - 1
				
				SetPixel( RedPixel, 	CInt(ValueOf(RedPixel))	  + param->Red	    )
				SetPixel( GreenPixel, 	CInt(ValueOf(GreenPixel)) + param->Green	)
				SetPixel( BluePixel, 	CInt(ValueOf(BluePixel))  + param->Blue 	)

			Next
		Next
					
	End Sub
	
	' PixelOffset filter - should this be renamed to DisplacePixel?
	Sub PixelOffset(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Math.Point Pointer)
		
		Dim As Any Pointer clone = ImageCreate(W, H, Color.Transparent, BPP * 8)
		Dim As Any Pointer original = pixels - SizeOf(FB.IMAGE)
		
		Put clone, (0, 0), original, (0, 0) - Step (W, H), PSet
		
		Dim As Any Pointer clonePixels = clone + SizeOf(FB.IMAGE)
		Dim As Integer clonePitch = Cast(FB.IMAGE Pointer, clone)->Pitch
		Dim As Integer cloneBPP = Cast(FB.IMAGE Pointer, clone)->BPP
		
		For x As Integer = 0 To W - 1
			For y As Integer = 0 To H - 1
				ValueOf(ARGBPixel) = *Cast(UInteger Pointer, clonePixels + param[W * y + x].Y * clonePitch + param[W * y + x].X * cloneBPP)	
			Next
		Next
		
		ImageDestroy clone
		
	End Sub
	
	' PixelOffsetAntiAlias filter
	Sub PixelOffsetAntiAlias(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Math.PointF Pointer)
		
		Dim As Any Pointer clone = ImageCreate(W, H, Color.Transparent, BPP * 8)
		Dim As Any Pointer original = pixels - SizeOf(FB.IMAGE)
		
		Put clone, (0, 0), original, (0, 0) - Step (W, H), PSet
		
		Dim As Any Pointer clonePixels = clone + SizeOf(FB.IMAGE)
		Dim As Integer clonePitch = Cast(FB.IMAGE Pointer, clone)->Pitch
		Dim As Integer cloneBPP = Cast(FB.IMAGE Pointer, clone)->BPP
		
		Dim As Double xOffset, yOffset, fracX, fracY, mX, mY
		Dim As Integer ceilX, ceilY, floorX, floorY
		Dim As UByte b1, b2 
		
		For x As Integer = 0 To W - 1
			For y As Integer = 0 To H - 1
				
				xOffset = param[W * y + x].X
				yOffset = param[W * y + x].Y
				
				floorX = Int(xOffset)
				ceilX = floorX + 1
				fracX = xOffset - floorX
				mX = 1.0 - fracX
				
				floorY = Int(yOffset)
				ceilY = floorY + 1
				fracY = yOffset - floorY
				mY = 1.0 - fracY
				
				If floorY >= 0 And ceilY < H And floorX >= 0 And ceilX < W Then
					
					b1 = mX * *Cast(UByte Pointer, clonePixels + floorY * clonePitch + floorX * cloneBPP + 3) + fracX * *Cast(UByte Pointer, clonePixels + floorY * clonePitch + ceilX * cloneBPP + 3)
					b2 = mX * *Cast(UByte Pointer, clonePixels + ceilY * clonePitch + floorX * cloneBPP + 3) + fracX * *Cast(UByte Pointer, clonePixels + ceilY * clonePitch + ceilX * cloneBPP + 3)
					*AlphaPixel = mY * b1 + fracY * b2
					
					b1 = mX * *Cast(UByte Pointer, clonePixels + floorY * clonePitch + floorX * cloneBPP + 2) + fracX * *Cast(UByte Pointer, clonePixels + floorY * clonePitch + ceilX * cloneBPP + 2)
					b2 = mX * *Cast(UByte Pointer, clonePixels + ceilY * clonePitch + floorX * cloneBPP + 2) + fracX * *Cast(UByte Pointer, clonePixels + ceilY * clonePitch + ceilX * cloneBPP + 2)
					*RedPixel = mY * b1 + fracY * b2
					
					b1 = mX * *Cast(UByte Pointer, clonePixels + floorY * clonePitch + floorX * cloneBPP + 1) + fracX * *Cast(UByte Pointer, clonePixels + floorY * clonePitch + ceilX * cloneBPP + 1)
					b2 = mX * *Cast(UByte Pointer, clonePixels + ceilY * clonePitch + floorX * cloneBPP + 1) + fracX * *Cast(UByte Pointer, clonePixels + ceilY * clonePitch + ceilX * cloneBPP + 1)
					*GreenPixel = mY * b1 + fracY * b2
					
					b1 = mX * *Cast(UByte Pointer, clonePixels + floorY * clonePitch + floorX * cloneBPP) + fracX * *Cast(UByte Pointer, clonePixels + floorY * clonePitch + ceilX * cloneBPP)
					b2 = mX * *Cast(UByte Pointer, clonePixels + ceilY * clonePitch + floorX * cloneBPP) + fracX * *Cast(UByte Pointer, clonePixels + ceilY * clonePitch + ceilX * cloneBPP)
					*BluePixel = mY * b1 + fracY * b2
					
				EndIf

			Next
		Next
		
		ImageDestroy clone
		
	End Sub
	
	' Flip filter
	Sub Flip(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Integer Pointer)
		
		Dim As Math.Point Pointer px
		
		px = New Math.Point[W * H]
		
		For x As Integer = 0 To W - 1
			For y As Integer = 0 To H - 1
				px[W * y + x].X = IIf(ValueOf(param) And &h1, W - (x + 1), x)
				px[W * y + x].Y = IIf(ValueOf(param) And &h2, H - (y + 1), y)
			Next
		Next
		
		PixelOffset pixels, W, H, BPP, Pitch, px
		
		Delete[] px
		
	End Sub
	
	' Convolution filter
	Sub Convolution(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As ConvolutionMatrix Pointer)
		
		If param->Factor = 0 Then Return
		
		Dim As Integer px
		
		For x As Integer = 1 To W - 2
			For y As Integer = 1 To H - 2
				
				px = 0
				For wX As Integer = -1 To 1
					For wY As Integer = -1 To 1
						px += ValueOf(RedPixelXY(x + wX, y + wY)) * param->Weight(wX, wY)
					Next
				Next
				
				SetPixel( RedPixel, CInt(px / param->Factor + param->Offset) )				
				
				px = 0
				For wX As Integer = -1 To 1
					For wY As Integer = -1 To 1
						px += ValueOf(GreenPixelXY(x + wX, y + wY)) * param->Weight(wX, wY)
					Next
				Next
				
				SetPixel( GreenPixel, CInt(px / param->Factor + param->Offset) )
				
				px = 0
				For wX As Integer = -1 To 1
					For wY As Integer = -1 To 1
						px += ValueOf(BluePixelXY(x + wX, y + wY)) * param->Weight(wX, wY)
					Next
				Next
				
				SetPixel( BluePixel, CInt(px / param->Factor + param->Offset) )
				
			Next
		Next		
		
	End Sub
	
	' FindEdges filter
	Sub FindEdges(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Any Pointer)
		
		Dim m As ConvolutionMatrix
		
		m.Weight(-1, -1) = +1
		m.Weight( 0, -1) = +1
		m.Weight(+1, -1) = +1
		m.Weight(-1,  0) =  0
		m.Weight( 0,  0) =  0
		m.Weight(+1,  0) =  0
		m.Weight(-1, +1) = -1
		m.Weight( 0, +1) = -1
		m.Weight(+1, +1) = -1
		
		m.Factor = 1
		m.Offset = +127
		
		Convolution pixels, W, H, BPP, Pitch, VarPtr(m)
		
	End Sub
	
	' Blur filter
	Sub Blur(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Integer Pointer)
		
		Dim m As ConvolutionMatrix
		
		m.Weight(-1, -1) = +1
		m.Weight( 0, -1) = +1
		m.Weight(+1, -1) = +1
		m.Weight(-1,  0) = +1
		m.Weight( 0,  0) = IIf(param = 0, 1, ValueOf(param))
		m.Weight(+1,  0) = +1
		m.Weight(-1, +1) = +1
		m.Weight( 0, +1) = +1
		m.Weight(+1, +1) = +1
		
		m.Factor = m.Weight(0, 0) + 8
		m.Offset = 0
		
		Convolution pixels, W, H, BPP, Pitch, VarPtr(m)
		
	End Sub
	
	' Water filter
	Sub Water(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Integer Pointer)
		
		Dim As Short nWave = IIf(param = 0, 10, ValueOf(param))
		
		Dim As Math.PointF Pointer px = New Math.PointF[W * H]
		
		For x As Integer = 0 To W - 1
			For y As Integer = 0 To H - 1
				
				px[W * y + x].X = x + nWave * Sin(2 * Math.PI * y / 128)
				px[W * y + x].Y = y + nWave * Cos(2 * Math.PI * x / 128)
				
			Next
		Next
		
		PixelOffsetAntiAlias pixels, W, H, BPP, Pitch, px
		
		Delete[] px
		
	End Sub
	
	' Swirl filter
	Sub Swirl(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Double Pointer)
		
		Dim As Double fDegree = IIf(param = 0, 0.05, ValueOf(param))
		
		Dim As Math.PointF Pointer px = New Math.PointF[W * H]
		
		Dim As Math.Point center = Type<Math.Point>(W / 2, H / 2)
		
		Dim As Double theta, radius
		Dim As Integer trueX, trueY
		
		For x As Integer = 0 To W - 1
			For y As Integer = 0 To H - 1
				
				trueX = x - center.X
				trueY = y - center.Y
				
				theta = ATan2(trueY, trueX)
				radius = Sqr(trueX ^ 2 + trueY ^ 2)
				
				px[W * y + x].X = center.X + (radius * Cos(theta + fDegree * radius))
				px[W * y + x].Y = center.Y + (radius * Sin(theta + fDegree * radius))
				
			Next
		Next
		
		PixelOffsetAntiAlias pixels, W, H, BPP, Pitch, px
		
		Delete[] px
		
	End Sub
	
	' RandomJitter filter
	Sub RandomJitter(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Integer Pointer)
		
		Dim As Short nDegree = IIf(param = 0, 5, ValueOf(param))
		
		Dim As Math.Point Pointer px = New Math.Point[W * H]
		
		Dim As Integer newX, newY
		
		For x As Integer = 0 To W - 1
			For y As Integer = 0 To H - 1
				
				newX = Math.Random(-nDegree, nDegree)
				newY = Math.Random(-nDegree, nDegree)
				
				If x + newX >= 0 And x + newX < W Then
					px[W * y + x].X = newX + x
				Else
					px[W * y + x].X = x
				EndIf
				
				If y + newY >= 0 And y + newY < H Then
					px[W * y + x].Y = newY + y
				Else
					px[W * y + x].Y = y
				EndIf
				
			Next
		Next
		
		PixelOffset pixels, W, H, BPP, Pitch, px
		
		Delete[] px
		
	End Sub
	
	' Mozaic filter
	Sub Mozaic(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Integer Pointer)
		
		Dim As Short nSize = IIf(param = 0, 10, ValueOf(param))
		
		Dim As Math.Point Pointer px = New Math.Point[W * H]
		
		Dim As Integer newX, newY, half = nSize \ 2
		
		For x As Integer = 0 To W - 1
			For y As Integer = 0 To H - 1
				
				newX = x Mod nSize - half
				newY = y Mod nSize - half
				
				If x + newX >= 0 And x + newX < W Then
					px[W * y + x].X = newX + x
				Else
					px[W * y + x].X = x
				EndIf
				
				If y + newY >= 0 And y + newY < H Then
					px[W * y + x].Y = newY + y
				Else
					px[W * y + x].Y = y
				EndIf
				
			Next
		Next
		
		PixelOffset pixels, W, H, BPP, Pitch, px
		
		Delete[] px
		
	End Sub
	
	


	' make sure theese are not used anywhere else
	#Undef AlphaPixel
	#Undef RedPixel
	#Undef GreenPixel
	#Undef BluePixel
	#Undef ValueOf
	#Undef SetPixel
	#Undef RedPixelXY
	#Undef GreenPixelXY
	#Undef BluePixelXY
	#Undef ARGBPixel	

#EndIf