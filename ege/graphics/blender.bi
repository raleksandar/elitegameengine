'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_BLENDER_BI__
#Define __EGE_BLENDER_BI__

	Namespace Blender
		
		Declare Function Transparent(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger 
		Declare Function Normal(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger		
		Declare Function Multiply(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger		
		Declare Function Screen(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Darken(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Lighten(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Difference(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Exclusion(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Negation(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Stamp(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Average(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Overlay(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function HardLight(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger		
		Declare Function SoftLight(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function ColorDodge(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function InvColorDodge(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger		
		Declare Function SoftDodge(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function ColorBurn(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function InvColorBurn(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function SoftBurn(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Reflect(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Glow(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Freeze(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Heat(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Additive(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Subtractive(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Red(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Green(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		Declare Function Blue(ByVal src As UInteger, ByVal dest As UInteger, ByVal parameter As Integer Pointer) As UInteger
		
		IncludeSource( "blender.bas" )
				
	End Namespace

#EndIf