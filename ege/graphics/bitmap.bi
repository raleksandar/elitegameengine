'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_BITMAP_BI__
#Define __EGE_BITMAP_BI__
	
	Enum RasterOp
		
		' standard GFXLib 2 blend modes
		fbPSet
		fbPReset
		fbTrans
		fbAnd
		fbOr
		fbXor
		fbAlpha
		fbAdd
		
		' Photoshop-like blend modes
		fbTransparent
		fbNormal
		fbMultiply
		fbScreen
		fbDarken
		fbLighten
		fbDifference
		fbExclusion
		fbNegation
		fbInterpolation
		fbStamp
		fbAverage
		fbOverlay
		fbHardLight
		fbSoftLight
		fbColorDodge
		fbInvColorDodge
		fbSoftDodge
		fbColorBurn
		fbInvColorBurn
		fbSoftBurn
		fbReflect
		fbGlow
		fbFreeze
		fbHeat
		fbAdditive
		fbSubtractive
		fbRed
		fbGreen
		fbBlue
		
		
		' your own blend mode...
		fbCustom
		
	End Enum
	
	Enum BitmapFilter
		fbNone
		fbInvert
		fbGrayscale
		fbBrightness
		fbContrast
		fbRedChannel
		fbGreenChannel
		fbBlueChannel
		fbColorOffset
		fbPixelOffset			' should be renamed to fbDisplacePixel
		fbPixelOffsetAntiAlias
		fbFlip
		fbConvolution
		fbFindEdges
		fbBlur
		fbWater
		fbSwirl
		fbRandomJitter
		fbMozaic
		fbCustom
		
		fbFirst = fbNone
		fbLast = fbCustom - 1
	End Enum
	
	Enum FlipDirection
		fbHorisontal = &H1
		fbVertical = &H2
		fbBoth = fbHorisontal Or fbVertical
	End Enum
	
	Enum ResizeMethod
		fbRepeatX = &H2
		fbScaleX = &H4
		fbRepeatY = &H20
		fbScaleY = &H40
		fbBilinear = &H100
		fbRepeat = fbRepeatX Or fbRepeatY
		fbScale = fbScaleX Or fbScaleY
		fbScaleBilinear = fbScale Or fbBilinear
	End Enum
	
	Type CustomBlenderProc As Function(ByVal source_pixel As UInteger, ByVal destination_pixel As UInteger, ByVal parameter As Any Pointer) As UInteger
	Type CustomFilterProc As Sub(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Any Pointer) 
	
	Type Bitmap 
		
		Public:
		
			Declare Property Handle	As Any Pointer
			Declare Property Handle(h As Any Pointer)
			
			Declare Property Width As UInteger
			Declare Property Height As UInteger
			
			Declare Property BPP As Integer
			Declare Property Pitch As UInteger
			
			Declare Sub DrawTo(dest As Any Pointer, dstX As Integer = 0, dstY As Integer = 0, srcX As Integer = 0, srcY As Integer = 0, W As Integer = 0, H As Integer = 0, method As RasterOp = fbAlpha, blender As CustomBlenderProc = NullPtr, param As Any Pointer = NullPtr)
			Declare Sub DrawTo(dest As Bitmap, dstX As Integer = 0, dstY As Integer = 0, srcX As Integer = 0, srcY As Integer = 0, W As Integer = 0, H As Integer = 0, method As RasterOp = fbAlpha, blender As CustomBlenderProc = NullPtr, param As Any Pointer = NullPtr)

			Declare Property Alpha As UByte
			Declare Property Alpha(a As UByte)
			
			Declare Sub PreserveAlphaChannel

			Declare Property Pixel(pt As Point) As UInteger
			Declare Property Pixel(pt As Point, value As UInteger)
			
			Declare Property PixelAlpha(pt As Point) As UByte
			Declare Property PixelRed(pt As Point) As UByte
			Declare Property PixelGreen(pt As Point) As UByte
			Declare Property PixelBlue(pt As Point) As UByte
			
			Declare Sub Crop(X As Integer, Y As Integer, W As Integer, H As Integer)
			Declare Sub Crop(W As Integer, H As Integer)
			
			Declare Sub Resize(W As Integer, H As Integer, method As ResizeMethod = fbScale)			

			Declare Function Copy(hnd As Any Pointer, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0) As Elite.Boolean
			Declare Function Copy(bmp As Bitmap, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0) As Elite.Boolean
			Declare Function Create(w As Integer, h As Integer, clr As UInteger = Color.Magenta, bpp As Integer = 32) As Elite.Boolean
			Declare Function LoadFromFile(Filename As String, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0) As Elite.Boolean
			Declare Function LoadFromMemory(mem As Any Pointer, size As Integer, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0) As Elite.Boolean
			
			Declare Sub Destroy	
			
			Declare Constructor(hnd As Any Pointer = NullPtr, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0)
			Declare Constructor(bmp As Bitmap, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0)
			Declare Constructor(w As Integer, h As Integer, clr As UInteger = Color.Magenta, bpp As Integer = 32)
			Declare Constructor(Filename As String, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0)
			Declare Constructor(mem As Any Pointer, size As Integer, X As Integer = 0, Y As Integer = 0, W As Integer = 0, H As Integer = 0)
			
			Declare Destructor
			
			Declare Sub ApplyFilter(filter As BitmapFilter, param As Any Pointer = 0, proc As CustomFilterProc = 0)
		
		Private:
			
			iW				As UInteger
			iH				As UInteger
			iBPP			As Integer
			iPitch			As UInteger
			imgHandle		As Any Pointer = NullPtr
			iAlpha			As UByte = 255
			iAlphaChannel	As UByte Pointer = NullPtr
			
	End Type
	
	Declare Operator =(lhs As Bitmap, rhs As Any Pointer) As Integer
	Declare Operator =(lhs As Any Pointer, rhs As Bitmap) As Integer
	Declare Operator =(lhs As Bitmap, rhs As Bitmap) As Integer
		
	Declare Operator <>(lhs As Bitmap, rhs As Any Pointer) As Integer
	Declare Operator <>(lhs As Any Pointer, rhs As Bitmap) As Integer
	Declare Operator <>(lhs As Bitmap, rhs As Bitmap) As Integer		
	
	
	IncludeSource( "bitmap.bas" )		
	
#EndIf