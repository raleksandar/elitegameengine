'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_BITMAP_BAS__
#Define __EGE_BITMAP_BAS__
	
	#Include "resize.bas"	' Bitmap.Resize implementation
	
	Property Bitmap.Handle	As Any Pointer
		Return This.imgHandle
	End Property
	
	Property Bitmap.Handle(h As Any Pointer)
		Assert( IsValidPtr( h ) )
		This.imgHandle = h
		This.iW = Cast(FB.IMAGE Pointer, h)->Width
		This.iH = Cast(FB.IMAGE Pointer, h)->Height
		This.iBPP = Cast(FB.IMAGE Pointer, h)->BPP
		This.iPitch = Cast(FB.IMAGE Pointer, h)->Pitch
	End Property
	
	Property Bitmap.Width As UInteger
		Return This.iW
	End Property
	
	Property Bitmap.Height As UInteger
		Return This.iH
	End Property
	
	Property Bitmap.BPP As Integer
		Return This.iBPP
	End Property
	
	Property Bitmap.Pitch As UInteger
		Return This.iPitch
	End Property
	
	Property Bitmap.Alpha As UByte
		Return This.iAlpha
	End Property
	
	Property Bitmap.Alpha(a As UByte)
		
		Assert( IsValidPtr( This.imgHandle ) )
		
		If This.iBPP = 4 Then
			
			Dim As Single newalpha
			Dim As UByte Pointer px = NullPtr
			Dim As Integer i
			
			If IsValidPtr( This.iAlphaChannel ) Then
				
				' we have alpha channel preserved, cool we can set real alpha value!
				
				newalpha = a / 255

				For X As Integer = 0 To This.iW - 1
					For Y As Integer = 0 To This.iH - 1
						*Cast(UByte Pointer, This.imgHandle + SizeOf(FB.IMAGE) + Y * This.iPitch + X * This.iBPP + 3) = This.iAlphaChannel[i] * newalpha
						i += 1
					Next
				Next			
				
			Else

				' this will lose some alpha information due to nature of division operation
				' but it's best we can do when we don't have alpha channel preserved
				
				newalpha = (Max(a, 25) / 255) / (Max(This.iAlpha, 25) / 255)
				
				For X As Integer = 0 To This.iW - 1
					For Y As Integer = 0 To This.iH - 1
						px = Cast(UByte Pointer, This.imgHandle + SizeOf(FB.IMAGE) + Y * This.iPitch + X * This.iBPP + 3)
						If *px > 5 Then
							 *px *= newalpha
						EndIf
					Next
				Next
				
			EndIf

		
		EndIf
		
		This.iAlpha = a
		
	End Property
	
	Sub Bitmap.PreserveAlphaChannel
		
		Assert( IsValidPtr( This.imgHandle ) )
		
		Dim As Integer i = 0
		
		NullDeleteArray( This.iAlphaChannel )
		
		This.iAlphaChannel = New UByte[This.iW * This.iH]
		
		For X As Integer = 0 To This.iW - 1
			For Y As Integer = 0 To This.iH - 1
				This.iAlphaChannel[i] = *Cast(UByte Pointer, This.imgHandle + SizeOf(FB.IMAGE) + Y * This.iPitch + X * This.iBPP + 3) 
				i += 1
			Next
		Next
		
	End Sub
	

	Property Bitmap.Pixel(pt As Point) As UInteger
		Assert( IsValidPtr( This.imgHandle ) )
		Return *Cast(UInteger Pointer, This.imgHandle + SizeOf(FB.IMAGE) + pt.Y * This.iPitch + pt.X * This.iBPP)
	End Property
	
	Property Bitmap.Pixel(pt As Point, value As UInteger)
		Assert( IsValidPtr( This.imgHandle ) )
		*Cast(UInteger Pointer, This.imgHandle + SizeOf(FB.IMAGE) + pt.Y * This.iPitch + pt.X * This.iBPP) = value	
	End Property
	
	Property Bitmap.PixelAlpha(pt As Point) As UByte
		Assert( IsValidPtr( This.imgHandle ) )
		Return *Cast(UByte Pointer, This.imgHandle + SizeOf(FB.IMAGE) + pt.Y * This.iPitch + pt.X * This.iBPP + 3)	
	End Property
	
	Property Bitmap.PixelRed(pt As Point) As UByte
		Assert( IsValidPtr( This.imgHandle ) )
		Return *Cast(UByte Pointer, This.imgHandle + SizeOf(FB.IMAGE) + pt.Y * This.iPitch + pt.X * This.iBPP + 2)	
	End Property
	
	Property Bitmap.PixelGreen(pt As Point) As UByte
		Assert( IsValidPtr( This.imgHandle ) )
		Return *Cast(UByte Pointer, This.imgHandle + SizeOf(FB.IMAGE) + pt.Y * This.iPitch + pt.X * This.iBPP + 1)
	End Property
	
	Property Bitmap.PixelBlue(pt As Point) As UByte
		Assert( IsValidPtr( This.imgHandle ) )
		Return *Cast(UByte Pointer, This.imgHandle + SizeOf(FB.IMAGE) + pt.Y * This.iPitch + pt.X * This.iBPP + 0)
	End Property

	
	Sub Bitmap.DrawTo(dest As Any Pointer, dstX As Integer = 0, dstY As Integer = 0, srcX As Integer = 0, srcY As Integer = 0, W As Integer = 0, H As Integer = 0, method As RasterOp = fbAlpha, customBlender As CustomBlenderProc = NullPtr, param As Any Pointer = NullPtr)
		
		Assert( IsValidPtr( This.imgHandle ) )
		
		If This.iBPP = 4 And This.iAlphaChannel = 0 And This.iAlpha < 4 Then Exit Sub
		
		If W < 1 Then W = This.iW
		If H < 1 Then H = This.iH
		
		' it's really sad why it's not possible to set raster operation with numerical constants, 
		' but instead of that keywords must be used (which is very unflexible)
		
		#Define GFXLibMode(m) Case RasterOp.fb##m:Put dest, (dstX, dstY), This.imgHandle, (srcX, srcY) - Step (W, H), m
		#Define CustomMode(m) Case RasterOp.fb##m:Put dest, (dstX, dstY), This.imgHandle, (srcX, srcY) - Step (W, H), Custom, ProcPtr(Blender.##m), VarPtr(This.iBPP)
		
		Select Case As Const method

			'GFXLibMode( Alpha )
			Case RasterOp.fbAlpha
				If IsValidPtr( param ) Then
					Put dest, (dstX, dstY), This.imgHandle, (srcX, srcY) - Step (W, H), Alpha, *Cast(Integer Pointer, param)
				Else
					Put dest, (dstX, dstY), This.imgHandle, (srcX, srcY) - Step (W, H), Alpha
				EndIf
			
			GFXLibMode( PSet )
			GFXLibMode( Trans )
			GFXLibMode( Xor )
			GFXLibMode( PReset )
			GFXLibMode( And )
			GFXLibMode( Or )
			GFXLibMode( Add )
			
			CustomMode( Transparent )
			CustomMode( Normal )
			CustomMode( Multiply )
			CustomMode( Screen )
			CustomMode( Darken )
			CustomMode( Lighten )
			CustomMode( Difference )
			CustomMode( Exclusion )
			CustomMode( Negation )
			CustomMode( Interpolation )
			CustomMode( Stamp )
			CustomMode( Average )
			CustomMode( Overlay )
			CustomMode( HardLight )
			CustomMode( SoftLight )
			CustomMode( ColorDodge )
			CustomMode( InvColorDodge )
			CustomMode( SoftDodge )
			CustomMode( ColorBurn )
			CustomMode( InvColorBurn )
			CustomMode( SoftBurn )
			CustomMode( Reflect )
			CustomMode( Glow )
			CustomMode( Freeze )
			CustomMode( Heat )
			CustomMode( Additive )
			CustomMode( Subtractive )
			CustomMode( Red )
			CustomMode( Green )
			CustomMode( Blue )
			
			Case RasterOp.fbCustom
				Put dest, (dstX, dstY), This.imgHandle, (srcX, srcY) - Step (W, H), Custom, customBlender, param								
				
		End Select
		
		#Undef GFXLibMode
		#Undef CustomMode
		
	End Sub
	
	Sub Bitmap.DrawTo(dest As Bitmap, dstX As Integer = 0, dstY As Integer = 0, srcX As Integer = 0, srcY As Integer = 0, W As Integer = 0, H As Integer = 0, method As RasterOp = fbAlpha, blender As CustomBlenderProc = NullPtr, param As Any Pointer = NullPtr)
		
		This.DrawTo dest.Handle, dstX, dstY, srcX, srcY, W, H, method, blender, param
		
	End Sub
	
	Sub Bitmap.Crop(X As Integer, Y As Integer, W As Integer, H As Integer)
		
		Assert( IsValidPtr( This.imgHandle ) )
		
		Dim As Any Pointer newImage = ImageCreate(W, H, Color.Transparent, This.iBPP * 8)
		
		This.DrawTo newImage, 0, 0, X, Y, W, H, fbPSet
		
		This.Destroy
		
		This.iW = W
		This.iH = H
		This.iPitch = Cast(FB.IMAGE Pointer, newImage)->pitch
		
		This.imgHandle = newImage
		
	End Sub
	
	Sub Bitmap.Crop(W As Integer, H As Integer)
		
		This.Crop 0, 0, W, H
		
	End Sub
	

	Function Bitmap.Copy(hnd As Any Pointer, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0) As Elite.Boolean
		
		This.Destroy
		
		If Not IsValidPtr( hnd ) Then Return Elite.False
		
		If W < 1 Then W = Cast(FB.IMAGE Pointer, hnd)->Width
		If H < 1 Then H = Cast(FB.IMAGE Pointer, hnd)->Height

		This.iW = W
		This.iH = H		
		
		This.imgHandle = ImageCreate(This.iW, This.iH, Color.Transparent, This.iBPP * 8)
		
		This.iBPP = Cast(FB.IMAGE Pointer, This.imgHandle)->bpp 
		This.iPitch = Cast(FB.IMAGE Pointer, This.imgHandle)->pitch
		
		Put This.imgHandle, (0, 0), hnd, (X, Y) - Step (W, H), PSet
		
		Return Elite.True
				
	End Function
	
	Function Bitmap.Copy(bmp As Bitmap, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0) As Elite.Boolean
		
		Return This.Copy(bmp.Handle, X, Y, W, H)
		
	End Function
	
	Function Bitmap.Create(w As Integer, h As Integer, clr As UInteger = Color.Magenta, depth As Integer = 32) As Elite.Boolean
		
		This.Destroy
		
		This.imgHandle = ImageCreate(w, h, clr, depth)
		
		If Not IsValidPtr( This.imgHandle ) Then Return Elite.False
		
		This.iW = w
		This.iH = h
		This.iBPP = Cast(FB.IMAGE Pointer, This.imgHandle)->bpp
		This.iPitch = Cast(FB.IMAGE Pointer, This.imgHandle)->pitch
		
		Return Elite.True
	
	End Function
	
	Function Bitmap.LoadFromFile(Filename As String, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0) As Elite.Boolean
		
		This.Destroy
		
		Dim As Any Pointer 		tmp = PNG_Load(Filename, PNG_TARGET_FBNEW)
		
		If Not IsValidPtr( tmp ) Then Return Elite.False
		
		Dim As Elite.Boolean	nocopy = (X = 0) And (Y = 0) And (W = 0) And (H = 0) 
		
		If W < 1 Then W = Cast(FB.IMAGE Pointer, tmp)->Width
		If H < 1 Then H = Cast(FB.IMAGE Pointer, tmp)->Height
		
		This.iW = W
		This.iH = H
		
		If nocopy Then
			
			This.imgHandle = tmp
			
		Else
			
			This.imgHandle = ImageCreate(W, H, Color.Transparent, This.iBPP * 8)
			
			Put This.imgHandle, (0, 0), tmp, (X, Y) - Step (W, H), PSet
			
			ImageDestroy(tmp)

		EndIf
		
		This.iBPP =  Cast(FB.IMAGE Pointer, This.imgHandle)->bpp
		This.iPitch =  Cast(FB.IMAGE Pointer, This.imgHandle)->pitch
		
		Return Elite.True
			
	End Function
	
	Function Bitmap.LoadFromMemory(mem As Any Pointer, size As Integer, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0) As Elite.Boolean
		
		This.Destroy
		
		Dim As Any Pointer 		tmp = PNG_Load_Mem(mem, size, PNG_TARGET_FBNEW)
		
		If Not IsValidPtr( tmp ) Then Return Elite.False
		
		Dim As Elite.Boolean	nocopy = (X = 0) And (Y = 0) And (W = 0) And (H = 0)
		
		If W < 1 Then W = Cast(FB.IMAGE Pointer, tmp)->Width
		If H < 1 Then H = Cast(FB.IMAGE Pointer, tmp)->Height
		
		If nocopy Then
			
			This.imgHandle = tmp
			
		Else
			
			This.imgHandle = ImageCreate(W, H, Color.Transparent, This.iBPP * 8)
			
			Put This.imgHandle, (0, 0), tmp, (X, Y) - Step (W, H), PSet
			
			ImageDestroy(tmp)

		EndIf
		
		This.iBPP =  Cast(FB.IMAGE Pointer, This.imgHandle)->bpp
		This.iPitch =  Cast(FB.IMAGE Pointer, This.imgHandle)->pitch
		
		Return Elite.True
	
	End Function
	
	Sub Bitmap.Destroy
		
		If IsValidPtr( This.imgHandle ) Then 
		
			ImageDestroy This.imgHandle
		
			This.imgHandle = NullPtr
		
		EndIf
		
		NullDeleteArray( This.iAlphaChannel )
		
	End Sub	
	
	Sub Bitmap.ApplyFilter(filter As BitmapFilter, param As Any Pointer = 0, proc As CustomFilterProc = 0)
		
		Assert( IsValidPtr( This.imgHandle ) )
		
		Dim As Any Pointer pixels = This.imgHandle + SizeOf(FB.IMAGE)
		Dim As Color.RGBTriple Pointer tmp
		
		Select Case As Const filter
			
			Case BitmapFilter.fbInvert
				Graphics.Filter.Invert(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)
			
			Case BitmapFilter.fbGrayscale
				Graphics.Filter.Grayscale(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)

			Case BitmapFilter.fbBrightness
				Graphics.Filter.Brightness(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)

			Case BitmapFilter.fbContrast
				Graphics.Filter.Contrast(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)

			Case BitmapFilter.fbRedChannel
				tmp = New Color.RGBTriple(0, -255, -255)
				Graphics.Filter.ColorOffset(pixels, This.iW, This.iH, This.iBPP, This.iPitch, tmp)
				Delete tmp

			Case BitmapFilter.fbGreenChannel
				tmp = New Color.RGBTriple(-255, 0, -255)
				Graphics.Filter.ColorOffset(pixels, This.iW, This.iH, This.iBPP, This.iPitch, tmp)
				Delete tmp

			Case BitmapFilter.fbBlueChannel
				tmp = New Color.RGBTriple(-255, -255, 0)
				Graphics.Filter.ColorOffset(pixels, This.iW, This.iH, This.iBPP, This.iPitch, tmp)
				Delete tmp

			Case BitmapFilter.fbColorOffset
				Graphics.Filter.ColorOffset(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)
			
			Case BitmapFilter.fbPixelOffset
				Graphics.Filter.PixelOffset(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)
			
			Case BitmapFilter.fbPixelOffsetAntiAlias
				Graphics.Filter.PixelOffsetAntiAlias(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)
			
			Case BitmapFilter.fbFlip
				Graphics.Filter.Flip(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)
			
			Case BitmapFilter.fbConvolution
				Graphics.Filter.Convolution(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)
			
			Case BitmapFilter.fbFindEdges
				Graphics.Filter.FindEdges(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)
			
			Case BitmapFilter.fbBlur
				Graphics.Filter.Blur(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)
			
			Case BitmapFilter.fbWater
				Graphics.Filter.Water(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)
			
			Case BitmapFilter.fbSwirl
				Graphics.Filter.Swirl(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)
			
			Case BitmapFilter.fbRandomJitter
				Graphics.Filter.RandomJitter(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)
			
			Case BitmapFilter.fbMozaic
				Graphics.Filter.Mozaic(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)								
			
			Case BitmapFilter.fbCustom
				proc(pixels, This.iW, This.iH, This.iBPP, This.iPitch, param)
			
		End Select	
		
	End Sub
		
	
	Constructor Bitmap(hnd As Any Pointer = NullPtr, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0)
		
		If IsValidPtr( hnd ) Then This.Copy(hnd, X, Y, W, H)
		
	End Constructor
	
	Constructor Bitmap(bmp As Bitmap, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0)
		
		This.Copy(bmp.Handle, X, Y, W, H)
		
	End Constructor
	
	Constructor Bitmap(w As Integer, h As Integer, clr As UInteger = Color.Magenta, depth As Integer = 32)
		
		This.Create(w, h, clr, depth)
	
	End Constructor
	
	Constructor Bitmap(Filename As String, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0)
		
		This.LoadFromFile(Filename, X, Y, W, H)
			
	End Constructor
	
	Constructor Bitmap(mem As Any Pointer, size As Integer, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0)
		
		This.LoadFromMemory(mem, size, X, Y, W, H)
	
	End Constructor
	
	Destructor Bitmap
		
		This.Destroy
	
	End Destructor
	
	
	
	Operator =(lhs As Bitmap, rhs As Any Pointer) As Integer
		Return lhs.Handle = rhs
	End Operator
	
	Operator =(lhs As Any Pointer, rhs As Bitmap) As Integer
		Return lhs = rhs.Handle
	End Operator

	Operator =(lhs As Bitmap, rhs As Bitmap) As Integer
		Return lhs.Handle = rhs.Handle
	End Operator	


	Operator <>(lhs As Bitmap, rhs As Any Pointer) As Integer
		Return lhs.Handle <> rhs
	End Operator
	
	Operator <>(lhs As Any Pointer, rhs As Bitmap) As Integer
		Return lhs <> rhs.Handle
	End Operator

	Operator <>(lhs As Bitmap, rhs As Bitmap) As Integer
		Return lhs.Handle <> rhs.Handle
	End Operator

#EndIf
