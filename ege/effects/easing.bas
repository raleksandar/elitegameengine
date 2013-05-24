'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_EASING_BAS__
#Define __EGE_EASING_BAS__
	
	Function Linear(t As Double, d As Double, b As Double, c As Double) As Double
		Return c * t / d + b	
	End Function
	
	Function EaseIn(t As Double, d As Double, b As Double, c As Double) As Double
		t /= d
		Return c * t ^ 2 + b
	End Function
	
	Function EaseOut(t As Double, d As Double, b As Double, c As Double) As Double
		Return -c * t ^ 2 / d ^ 2 + 2 * c * t / d + b
	End Function
	
	Function EaseInOut(t As Double, d As Double, b As Double, c As Double) As Double
		If t < d / 2 Then
			Return 2 * c * t ^ 2 / d ^ 2 + b
		Else
			Dim As Double tmp = t - d / 2
			Return -2 * c * tmp ^ 2 / d ^ 2 + 2 * c * tmp / d + c / 2 + b
		EndIf	
	End Function
	
	Function ExpoIn(t As Double, d As Double, b As Double, c As Double) As Double
		Dim As Double tmp = 1
		If c < 0 Then
			tmp = -1
			c = -c
		EndIf
		Return tmp * Exp(Log(c) / d * t) + b
	End Function
	
	Function ExpoOut(t As Double, d As Double, b As Double, c As Double) As Double
		Dim As Double tmp = 1
		If c < 0 Then
			tmp = -1
			c = -c
		EndIf
		Return tmp * (-Exp(-Log(c) / d * (t - d)) + c + 1) + b
	End Function
	
	Function ExpoInOut(t As Double, d As Double, b As Double, c As Double) As Double
		Dim As Double tmp = 1
		If c < 0 Then
			tmp = -1
			c = -c
		EndIf
		If t < d / 2 Then
			Return tmp * (Exp(Log(c / 2) / (d / 2) * t)) + b
		Else
			Return tmp * (-Exp(-2 * Log(c / 2) / d * (t - d)) + c + 1) + b
		EndIf
	End Function
	
	Function BounceOut(t As Double, d As Double, b As Double, c As Double) As Double
		t /= d
        If t < 1 / 2.75 Then
            Return c * (7.5625 * t ^ 2) + b
        ElseIf t < 2 / 2.75 Then
            t -= 1.5 / 2.75
            Return c * (7.5625 * t ^ 2 + 0.75) + b
        ElseIf t < 2.5 / 2.75 Then
            t -= 2.25 / 2.75
            Return c * (7.5625 * t ^ 2 + 0.9375) + b
        Else
            t -= 2.625 / 2.75
            Return c * (7.5625 * t ^ 2 + 0.984375) + b
        End If
	End Function
	
	Function BounceIn(t As Double, d As Double, b As Double, c As Double) As Double
		t = d - t
        Return c - BounceOut(t, d, 0, c) + b
	End Function
	
	Function BounceInOut(t As Double, d As Double, b As Double, c As Double) As Double
		t *= 2
		If t < d / 2 Then
			Return BounceIn(t, d, 0, c) * 0.5 + b
		Else
			t -= 2
			Return BounceOut(t, d, 0, c) * 0.5 + c * 0.5 + b
		EndIf
	End Function
	
	Function ElasIn(t As Double, d As Double, b As Double, c As Double) As Double
		If t = 0 Then
			Return b
		Else
			t /= d
            If t = 1 Then
                Return b + c
            Else
                Dim As Double tmp = (d * 0.3) / (2 * Math.PI) * 0.785398163397448
                t -= 1
                Return -(c * 2 ^ (10 * t) * Sin((t * d - tmp) * (2 * Math.PI) / (d * 0.3))) + b
            End If
		EndIf
	End Function
	
	Function ElasOut(t As Double, d As Double, b As Double, c As Double) As Double
		If t = 0 Then
            Return b
        Else
            t /= d
            If t = 1 Then
                Return b + c
            Else
                Dim As Double tmp = (d * 0.3) / (2 * Math.PI) * 0.785398163397448
                Return c * 2 ^ (-10 * t) * Sin((t * d - tmp) * (2 * Math.PI) / tmp) + c + b
            End If
        End If
	End Function
	
	Function ElasInOut(t As Double, d As Double, b As Double, c As Double) As Double
		If t = 0 Then
            Return b
        Else
            t /= (d / 2)
            If t = 2 Then
                Return b + c
            Else
                Dim As Double tmp = (d * 0.3) / (2 * Math.PI) * 0.785398163397448
                t -= 1
                If t < 1 Then
                    Return -0.5 * (c * 2 ^ (10 * t) * Sin((t * d - tmp) * (2 * Math.PI) / (d * 0.45))) + b
                Else
                    Return 1.70158 * 2 ^ (-10 * t) * Sin((t * d - 1.70158) * (2 * Math.PI) / (d * 0.45)) * 0.5 + c + b
                End If
            End If
        End If
	End Function
	
	Function BackIn(t As Double, d As Double, b As Double, c As Double) As Double
		t /= d
		Return c * t ^ 2 * (2.70158 * t - 1.70158) + b
	End Function
	
	Function BackOut(t As Double, d As Double, b As Double, c As Double) As Double
		t = t / d - 1
		Return c * (t ^ 2 * (2.70158 * t + 1.70158) + 1) + b
	End Function
	
	Function BackInOut(t As Double, d As Double, b As Double, c As Double) As Double
		t /= (d / 2)
		If t < 1 Then
            Return c / 2 * (t ^ 2 * (3.5949095 * t - 2.5949095)) + b
        Else
            t -= 2
            Return c / 2 * (t ^ 2 * (3.5949095 * t + 2.5949095) + 2) + b
        End If
	End Function
	
	Function CubicIn(t As Double, d As Double, b As Double, c As Double) As Double
		t /= d
		Return c * t ^ 3 + b
	End Function
	
	Function CubicOut(t As Double, d As Double, b As Double, c As Double) As Double
		t = t / d - 1
		Return c * (t ^ 3 + 1) + b
	End Function
	
	Function CubicInOut(t As Double, d As Double, b As Double, c As Double) As Double
		t /= (d / 2)
		If t < 1 Then
            Return c / 2 * t ^ 3 + b
        Else
            t -= 2
            Return c / 2 * (t ^ 3 + 2) + b
        End If
	End Function
	
	Function CircIn(t As Double, d As Double, b As Double, c As Double) As Double
		t /= d
		Return -c * (Sqr(1 - t ^ 2) - 1) + b
	End Function
	
	Function CircOut(t As Double, d As Double, b As Double, c As Double) As Double
		t = t / d - 1
		Return c * Sqr(1 - t ^ 2) + b
	End Function
	
	Function CircInOut(t As Double, d As Double, b As Double, c As Double) As Double
		t /= (d / 2)
		If t < 1 Then
			Return -c / 2 * (Sqr(1 - t ^ 2) - 1) + b
		Else
			t -= 2
			Return c / 2 * (Sqr(1 - t ^ 2) + 1) + b
		EndIf 
	End Function
	
	Function SineIn(t As Double, d As Double, b As Double, c As Double) As Double
		Return -c * Cos(t / d * (Math.PI / 2)) + c + b
	End Function
	
	Function SineOut(t As Double, d As Double, b As Double, c As Double) As Double
		Return c * Sin(t / d * (Math.PI / 2)) + b
	End Function
	
	Function SineInOut(t As Double, d As Double, b As Double, c As Double) As Double
		Return -c / 2 * (Cos(Math.PI * t / d) - 1) + b
	End Function

#EndIf