'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_EASING_BI__
#Define __EGE_EASING_BI__

	Enum Easing
		Linear
	    EaseIn
	    EaseOut
	    EaseInOut	    
	    ExpoIn
	    ExpoOut
	    ExpoInOut
	    BounceIn
	    BounceOut
	    BounceInOut
	    ElasIn
	    ElasOut
	    ElasInOut
	    BackIn
	    BackOut
	    BackInOut
	    CircIn
	    CircOut
	    CircInOut
	    SineIn
	    SineOut
	    SineInOut
	    CubicIn
	    CubicOut
	    CubicInOut	    
	End Enum

	Type EasingFunction As Function(t As Double, d As Double, b As Double, c As Double) As Double

	Namespace EasingFunc

		Declare Function Linear(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function EaseIn(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function EaseOut(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function EaseInOut(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function ExpoIn(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function ExpoOut(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function ExpoInOut(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function BounceIn(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function BounceOut(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function BounceInOut(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function ElasIn(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function ElasOut(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function ElasInOut(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function BackIn(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function BackOut(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function BackInOut(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function CubicIn(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function CubicOut(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function CubicInOut(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function CircIn(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function CircOut(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function CircInOut(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function SineIn(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function SineOut(t As Double, d As Double, b As Double, c As Double) As Double
		Declare Function SineInOut(t As Double, d As Double, b As Double, c As Double) As Double
		
		IncludeSource( "easing.bas" )		

	End Namespace

#EndIf