'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_BLENDER_BAS__
#Define __EGE_BLENDER_BAS__
	
	'
	'  Unit BlendModes (c) 2004 by Jens Gruschel
	'  http://www.pegtop.net/delphi/articles/blendmodes/
	'
	'
	'  rewritten in FreeBASIC by Aleksandar Ruzicic
	'

	
	' some useful macros for internal use only

	#Define AlphaPixel(ui) 	(Cast(UByte Pointer, VarPtr(ui)) + 3)
	#Define RedPixel(ui) 	(Cast(UByte Pointer, VarPtr(ui)) + 2)
	#Define GreenPixel(ui) 	(Cast(UByte Pointer, VarPtr(ui)) + 1)
	#Define BluePixel(ui) 	(Cast(UByte Pointer, VarPtr(ui)) + 0)
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
	
	#Macro SetAlpha()
	
		If alpha < 1.0 Then
			
			ValueOf(RedPixel(src)) = (1 - alpha) * ValueOf(RedPixel(dest)) + alpha * ValueOf(RedPixel(src))
			ValueOf(GreenPixel(src)) = (1 - alpha) * ValueOf(GreenPixel(dest)) + alpha * ValueOf(GreenPixel(src))
			ValueOf(BluePixel(src)) = (1 - alpha) * ValueOf(BluePixel(dest)) + alpha * ValueOf(BluePixel(src))
			ValueOf(AlphaPixel(src)) = ValueOf(AlphaPixel(dest))

		EndIf
		
	#EndMacro
	
	#Macro ApplyFormula(f)
		
		#Define func( srcPixel, destPixel ) f
		
		If ValueOf(parameter) = 4 Then ' 32-bit color
			
			Dim alpha As Single = ValueOf(AlphaPixel(src)) / 255
			
			If alpha < 0.001 Then Return dest
			
			SetPixel( RedPixel(src), 	func( ValueOf(RedPixel(src)),   ValueOf(RedPixel(dest))		) )
			SetPixel( GreenPixel(src),	func( ValueOf(GreenPixel(src)), ValueOf(GreenPixel(dest))	) )
			SetPixel( BluePixel(src), 	func( ValueOf(BluePixel(src)),  ValueOf(BluePixel(dest)) 	) )
			SetPixel( AlphaPixel(src), 	func( ValueOf(AlphaPixel(src)), ValueOf(AlphaPixel(dest))	) )
			
			SetAlpha()

		Else

			SetPixel( RedPixel(src), 	func( ValueOf(RedPixel(src)),   ValueOf(RedPixel(dest))		) )
			SetPixel( GreenPixel(src),	func( ValueOf(GreenPixel(src)), ValueOf(GreenPixel(dest))	) )
			SetPixel( BluePixel(src), 	func( ValueOf(BluePixel(src)),  ValueOf(BluePixel(dest)) 	) )				
			
		EndIf
					
		#Undef func
		
		Return src
	
	#EndMacro
	
	
	Dim Shared CosineTableInitialized	As Elite.Boolean
	Dim Shared CosineTable(0 To 255)	As UByte
	
	Sub InitializeCosineTable
		
		CosineTableInitialized = Elite.True
		
		For i As Integer = 0 To 255
			
			CosineTable(i) = Round( 64 - Cos(i * PI / 255) * 64 ) 
			
		Next
		
	End Sub

	
	Function Transparent(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
	
		Return dest
	
	End Function
	
	
	Function Normal(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula( srcPixel )
		
	End Function
	
	
	Function Multiply(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula(  (destPixel * srcPixel + 1) Shr 8  )	
		
	End Function
	
	
	Function Screen(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula(  255 - (((255 - destPixel) * (255 - srcPixel) + 1) Shr 8)  )	
		
	End Function
	
	
	Function Darken(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula(  IIf(destPixel < srcPixel, destPixel, srcPixel)  )
		
	End Function
	
	
	Function Lighten(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula(  IIf(destPixel > srcPixel, destPixel, srcPixel)  )	
		
	End Function

	
	Function Difference(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula(  Abs(destPixel - srcPixel)  )	
		
	End Function
	
	
	Function Exclusion(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula(  destPixel + srcPixel - ((destPixel * srcPixel + 1) Shr 7)  )	
		
	End Function
	

	Function Negation(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
			
		ApplyFormula(  255 - Abs(255 - destPixel - srcPixel)  )	
		
	End Function
	
	
	Function Interpolation(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
			
		If Not CosineTableInitialized Then InitializeCosineTable
		
		ApplyFormula( CosineTable(destPixel) + CosineTable(srcPixel) )	
		
	End Function


	Function Stamp(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
			
		ApplyFormula(  destPixel + 2 * srcPixel - 256  )	
		
	End Function
	
	
	Function Average(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
			
		ApplyFormula(  (destPixel + srcPixel + 1) Shr 1  )
		
	End Function
	
	
	Function Overlay(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
			
		ApplyFormula(  IIf(destPixel < 128, (destPixel * srcPixel + 1) Shr 7, 255 - (((255 - destPixel) * (255 - srcPixel) + 1) Shr 7) )  )	
		
	End Function
	
	
	Function HardLight(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula(  IIf(srcPixel < 128, (srcPixel * destPixel + 1) Shr 7, 255 - (((255 - srcPixel) * (255 - destPixel) + 1) Shr 7) )  )	
		
	End Function
	
	
	Function SoftLight(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
			
		ApplyFormula( (destPixel * srcPixel + 1) Shr 8 + destPixel * (256 - (((255 - destPixel) * (255 - srcPixel) + 1) Shr 8) - (destPixel * srcPixel + 1) Shr 8) Shr 8  )	
		
	End Function
	
	
	Function ColorDodge(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula( (destPixel Shl 8) / (256 - srcPixel)  )	
		
	End Function
	
	
	Function InvColorDodge(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula( (srcPixel Shl 8) / (256 - destPixel)  )	
		
	End Function
	
	
	Function SoftDodge(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
					
		ApplyFormula( IIf(destPixel + srcPixel < 256, (destPixel Shl 7) \ (256 - srcPixel), 255 - (((255 - srcPixel) Shl 7) \ (destPixel + 1))) )	
		
	End Function
	
	
	Function ColorBurn(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula( 255 - (((255 - destPixel) Shl 8) \ (srcPixel + 1)) )	
		
	End Function
	
	
	Function InvColorBurn(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula( 255 - (((255 - srcPixel) Shl 8) \ (destPixel + 1)) )	
		
	End Function
	
	
	Function SoftBurn(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula( IIf(destPixel + srcPixel < 256, (srcPixel Shl 7) \ (256 - destPixel), 255 - (((255 - destPixel) Shl 7) \ (srcPixel + 1))) )	
		
	End Function
	
	
	Function Reflect(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
			
		ApplyFormula( destPixel ^ 2 \ (256 - srcPixel) )	
		
	End Function
	
	
	Function Glow(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula( srcPixel ^ 2 \ (256 - destPixel) )	
		
	End Function
	
	
	Function Freeze(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula( 255 - (255 - destPixel) ^ 2 \ (srcPixel + 1) )	
		
	End Function
	
	
	Function Heat(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula( 255 - (255 - srcPixel) ^ 2 \ (destPixel + 1) )	
		
	End Function
	
	
	Function Additive(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula( srcPixel + destPixel )	
		
	End Function
	
	
	Function Subtractive(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		ApplyFormula( srcPixel + destPixel - 256 )	
		
	End Function
	
	
	Function Red(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		If ValueOf(parameter) = 4 Then ' 32-bit color
			
			Dim alpha As Single = ValueOf(AlphaPixel(src)) / 255
			
			If alpha < 0.1 Then Return dest
			
			SetPixel( RedPixel(src), 	ValueOf(RedPixel(src)) 		)
			SetPixel( GreenPixel(src), 	ValueOf(GreenPixel(dest))	)
			SetPixel( BluePixel(src), 	ValueOf(BluePixel(dest))	)
							
			SetAlpha()
						
		Else

			SetPixel( RedPixel(src), 	ValueOf(RedPixel(src)) 		)
			SetPixel( GreenPixel(src), 	ValueOf(GreenPixel(dest))	)
			SetPixel( BluePixel(src), 	ValueOf(BluePixel(dest))	)				
			
		EndIf	
		
		Return src
		
	End Function
	
	
	Function Green(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		If ValueOf(parameter) = 4 Then ' 32-bit color
			
			Dim alpha As Single = ValueOf(AlphaPixel(src)) / 255
			
			If alpha < 0.1 Then Return dest
			
			SetPixel( RedPixel(src), 	ValueOf(RedPixel(dest)) 	)
			SetPixel( GreenPixel(src), 	ValueOf(GreenPixel(src))	)
			SetPixel( BluePixel(src), 	ValueOf(BluePixel(dest))	)
							
			SetAlpha()
						
		Else

			SetPixel( RedPixel(src), 	ValueOf(RedPixel(dest)) 	)
			SetPixel( GreenPixel(src), 	ValueOf(GreenPixel(src))	)
			SetPixel( BluePixel(src), 	ValueOf(BluePixel(dest))	)				
			
		EndIf	
		
		Return src
		
	End Function
	
	
	Function Blue(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		If ValueOf(parameter) = 4 Then ' 32-bit color
			
			Dim alpha As Single = ValueOf(AlphaPixel(src)) / 255
			
			If alpha < 0.1 Then Return dest
			
			SetPixel( RedPixel(src), 	ValueOf(RedPixel(dest)) 	)
			SetPixel( GreenPixel(src), 	ValueOf(GreenPixel(dest))	)
			SetPixel( BluePixel(src), 	ValueOf(BluePixel(src))		)
							
			SetAlpha()
						
		Else

			SetPixel( RedPixel(src), 	ValueOf(RedPixel(dest)) 	)
			SetPixel( GreenPixel(src), 	ValueOf(GreenPixel(dest))	)
			SetPixel( BluePixel(src), 	ValueOf(BluePixel(src))		)				
			
		EndIf	
		
		Return src
		
	End Function
	

	' make sure theese are not used anywhere else
	#Undef AlphaPixel
	#Undef RedPixel
	#Undef GreenPixel
	#Undef BluePixel
	#Undef ValueOf
	#Undef SetPixel
	#Undef SetAlpha
	#Undef ApplyFormula	

#EndIf