'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_FILTERS_BI__
#Define __EGE_FILTERS_BI__
	
	Namespace Filter
		
		Type ConvolutionMatrix ' 3x3 matrix
			Weight(-1 To +1, -1 To +1)	As Integer
			Offset	As Integer
			Factor	As Integer 
		End Type
		
		Declare Sub Invert(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Any Pointer) 
		Declare Sub Grayscale(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Any Pointer) 
		Declare Sub Brightness(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Integer Pointer)
		Declare Sub Contrast(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Integer Pointer)		
		Declare Sub ColorOffset(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Color.RGBTriple Pointer)
		Declare Sub PixelOffset(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Math.Point Pointer)
		Declare Sub PixelOffsetAntiAlias(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Math.PointF Pointer)
		Declare Sub Flip(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Integer Pointer)
		Declare Sub Convolution(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As ConvolutionMatrix Pointer)
		Declare Sub FindEdges(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Any Pointer)
		Declare Sub Blur(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Integer Pointer)
		Declare Sub Water(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Integer Pointer)
		Declare Sub Swirl(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Double Pointer)
		Declare Sub RandomJitter(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Integer Pointer)
		Declare Sub Mozaic(pixels As Any Pointer, W As Integer, H As Integer, BPP As Integer, Pitch As Integer, param As Integer Pointer)

		IncludeSource( "filters.bas" )
		
	End Namespace
	
#EndIf	