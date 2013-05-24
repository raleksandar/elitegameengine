'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_MATH_BAS__
#Define __EGE_MATH_BAS__


	Function Rect.HasPoint(X As Integer, Y As Integer) As Elite.Boolean
		Return (X >= This.X) And (X <= This.X + This.W) And (Y >= This.Y) And (Y <= This.Y + This.H)	
	End Function
	
	Function Rect.HasPoint(X As Double, Y As Double) As Elite.Boolean
		Return (X >= This.X) And (X <= This.X + This.W) And (Y >= This.Y) And (Y <= This.Y + This.H)
	End Function
	
	Function Rect.HasPoint(pt As Point) As Elite.Boolean
		Return (pt.X >= This.X) And (pt.X <= This.X + This.W) And (pt.Y >= This.Y) And (pt.Y <= This.Y + This.H)
	End Function
	
	Function Rect.HasPoint(pt As PointF) As Elite.Boolean
		Return (pt.X >= This.X) And (pt.X <= This.X + This.W) And (pt.Y >= This.Y) And (pt.Y <= This.Y + This.H)
	End Function
	


	Function RectF.HasPoint(X As Integer, Y As Integer) As Elite.Boolean
		Return (X >= This.X) And (X <= This.X + This.W) And (Y >= This.Y) And (Y <= This.Y + This.H)	
	End Function
	
	Function RectF.HasPoint(X As Double, Y As Double) As Elite.Boolean
		Return (X >= This.X) And (X <= This.X + This.W) And (Y >= This.Y) And (Y <= This.Y + This.H)
	End Function
	
	Function RectF.HasPoint(pt As Point) As Elite.Boolean
		Return (pt.X >= This.X) And (pt.X <= This.X + This.W) And (pt.Y >= This.Y) And (pt.Y <= This.Y + This.H)
	End Function
	
	Function RectF.HasPoint(pt As PointF) As Elite.Boolean
		Return (pt.X >= This.X) And (pt.X <= This.X + This.W) And (pt.Y >= This.Y) And (pt.Y <= This.Y + This.H)
	End Function
	
	
	
	Function Choice.MakeChoice As Integer
		
		Dim rand	As Integer = Random(0, 100)
		Dim sum		As Integer = 0
		
		For i As Integer = 0 To This.iNumChoices
			
			sum += This.iChoice[i]
			
			If rand < sum Then Return i + 1
			
		Next
		
	End Function
			
	Property Choice.LastChoice	As Integer
		Return This.LastChoice
	End Property
			
	Property Choice.Probability(Index As Integer, percent As Integer)
		This.iChoice[Index - 1] = Constrain(percent, 1, 100)
	End Property
	
	Property Choice.Probability(Index As Integer) As Integer
		Return This.iChoice[Index - 1] 
	End Property 
			
	Constructor Choice(numPosibilities As Integer)
		
		This.iNumChoices = numPosibilities
		
		This.iChoice = New Integer[numPosibilities]
		
		Dim As Integer percent = 100 \ numPosibilities 
		
		For i As Integer = 0 To numPosibilities - 1
			
			This.iChoice[i] = percent
			
		Next
		
		This.iChoice[numPosibilities - 1] += 100 Mod numPosibilities
		
	End Constructor
	
	Destructor Choice
		Delete[] This.iChoice
	End Destructor
	
	
		
	Function Round(n As Double) As Integer
		Return IIf(Abs(n) - Int(Abs(n)) < 0.5, Int(n), Int(n) + Sgn(n))
	End Function
	


	Function Min(a As Integer, b As Integer) As Integer		
		Return IIf(a < b, a, b)		
	End Function		
	
	Function Min(a As Double, b As Double) As Double
		Return IIf(a < b, a, b)
	End Function



	Function Max(a As Integer, b As Integer) As Integer		
		Return IIf(a > b, a, b)		
	End Function		
	
	Function Max(a As Double, b As Double) As Double
		Return IIf(a > b, a, b)
	End Function		



	Function Constrain(value As Integer, a As Integer, b As Integer) As Integer		
		Return Min(Max(value, a), b)		
	End Function		
	
	Function Constrain(value As Double, a As Double, b As Double) As Double
		Return Min(Max(value, a), b)
	End Function				
	
	
	
	Sub NextValue(ByRef current As Integer, a As Integer, b As Integer)
		current = Max(current + 1, a)
		If current > b Then current = a	
	End Sub
	
	Sub NextValue(ByRef current As Double, a As Double, b As Double)
		current = Max(current + 1, a)
		If current > b Then current = a			
	End Sub


	
	Sub PrevValue(ByRef current As Integer, a As Integer, b As Integer)
		current = Min(current - 1, b)
		If current < a Then current = b
	End Sub
	
	Sub PrevValue(ByRef current As Double, a As Double, b As Double)
		current = Min(current - 1, b)
		If current < a Then current = b
	End Sub		
	
	
	
	Function Random(iMin As Integer = 0, iMax As Integer = 10) As Integer
		Return Int(Rnd * (iMax - iMin + 1)) + iMin
	End Function
	
	Function LastRandom As Integer
		Return Rnd(0)
	End Function
	
#EndIf