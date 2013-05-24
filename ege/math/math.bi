'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_MATH_BI__
#Define __EGE_MATH_BI__
	
	Namespace Math
		
		Const PI		As Double = Atn(1) * 4
		Const E			As Double = Exp(1)
		
		Const MulToRads	As Double = PI / 180
		Const MulToDegs	As Double = 180 / PI
		
		#Define Deg2Rad(DEGREES) ((DEGREES) * Elite.Math.MulToRads)
		#Define Rad2Deg(RADIANS) ((RADIANS) * Elite.Math.MulToDegs)


		Type Point
			X	As Integer
			Y	As Integer
		End Type
		
		Type PointF
			X	As Double
			Y	As Double
		End Type
		
		
		
		Type Rect
			X	As Integer
			Y	As Integer
			W	As Integer
			H	As Integer
			Declare Function HasPoint(X As Integer, Y As Integer) As Elite.Boolean
			Declare Function HasPoint(X As Double, Y As Double) As Elite.Boolean
			Declare Function HasPoint(pt As Point) As Elite.Boolean
			Declare Function HasPoint(pt As PointF) As Elite.Boolean
		End Type
		
		Type RectF
			X	As Double
			Y	As Double
			W	As Double
			H	As Double
			Declare Function HasPoint(X As Integer, Y As Integer) As Elite.Boolean
			Declare Function HasPoint(X As Double, Y As Double) As Elite.Boolean
			Declare Function HasPoint(pt As Point) As Elite.Boolean
			Declare Function HasPoint(pt As PointF) As Elite.Boolean
		End Type
		
		
		
		Type Choice
			
			Public:
				
				Declare Function MakeChoice As Integer
				
				Declare Property LastChoice	As Integer
				
				Declare Property Probability(Index As Integer, percent As Integer)
				Declare Property Probability(Index As Integer) As Integer 
				
				Declare Constructor(numPosibilities As Integer)
				Declare Destructor
				
			Private:
				
				iChoice		As Integer Pointer
				iNumChoices	As Integer
				iLastChoice	As Integer
			
		End Type
		
		
		Declare Function Round(n As Double) As Integer
		
		Declare Function Min OverLoad(a As Integer, b As Integer) As Integer
		Declare Function Min(a As Double, b As Double) As Double

		Declare Function Max OverLoad(a As Integer, b As Integer) As Integer
		Declare Function Max(a As Double, b As Double) As Double		

		Declare Function Constrain OverLoad(value As Integer, a As Integer, b As Integer) As Integer
		Declare Function Constrain(value As Double, a As Double, b As Double) As Double		
		
		Declare Sub NextValue OverLoad(ByRef current As Integer, a As Integer, b As Integer)
		Declare Sub NextValue(ByRef current As Double, a As Double, b As Double)
		
		Declare Sub PrevValue OverLoad(ByRef current As Integer, a As Integer, b As Integer)
		Declare Sub PrevValue(ByRef current As Double, a As Double, b As Double)		
		
		Declare Function Random(min As Integer = 0, max As Integer = 10) As Integer
		Declare Function LastRandom As Integer
		
		IncludeSource( "math.bas" )
		
	End Namespace


#EndIf