'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_EFFECTS_BI__
#Define __EGE_EFFECTS_BI__

	Namespace Effect
		
		#Include "easing.bi"	' built-in easing functions
		
		Type Animation
			
			Public:
			
				Declare Constructor(numValues As Integer = 1, e As EasingFunction = Procptr(EasingFunc.Linear))
				Declare Constructor(numValues As Integer, e As Easing)
				Declare Constructor(e As Easing)
				Declare Constructor(e As EasingFunction)
				Declare Destructor

				Declare Property StartValue(newValue As Double)
				Declare Property StartValue As Double
				
				Declare Property StartValue(Index As Integer, newValue As Double)
				Declare Property StartValue(Index As Integer) As Double
				
				Declare Property EndValue(newValue As Double)
				Declare Property EndValue As Double
				
				Declare Property EndValue(Index As Integer, newValue As Double)
				Declare Property EndValue(Index As Integer) As Double

				Declare Property Value(newValue As Double)
				Declare Property Value As Double
				
				Declare Property Value(Index As Integer, newValue As Double)
				Declare Property Value(Index As Integer) As Double
				
				Declare Property EasingType(newValue As Easing)
				Declare Property EasingType As Easing
				
				Declare Property EasingProc(newValue As EasingFunction)
				Declare Property EasingProc As EasingFunction
				
				Declare Property EasingType(Index As Integer, newValue As Easing)
				Declare Property EasingType(Index As Integer) As Easing
				
				Declare Property EasingProc(Index As Integer, newValue As EasingFunction)
				Declare Property EasingProc(Index As Integer) As EasingFunction
				
				Declare Property TargetReached As Elite.Boolean
				Declare Property Playing As Elite.Boolean
				Declare Property Time As Integer
				
				Declare Sub Play(Duration As Double = 1.0)
				Declare Sub Stop
				
				Declare Sub onFrame()
				
				queueIndex	As UInteger
			
			Private:
				
				t			As Double
				d			As Double
				b			As Double
				c			As Double
				
				TimeStart	As Double
				
				dStart		As Double Pointer = NullPtr
				dEnd		As Double Pointer = NullPtr
				dCurrent	As Double Pointer = NullPtr
				
				iNumValues	As Integer
				
				onTarget	As Elite.Boolean
				running		As Elite.Boolean
				
				pEasing		As EasingFunction Pointer = NullPtr
				
		End Type 
		

	End Namespace

#EndIf