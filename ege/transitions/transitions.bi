'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_TRANSITIONS_BI__
#Define __EGE_TRANSITIONS_BI__
	
	Namespace Transition
		
		Declare Sub MakeTransition(transMethod As TransitionEffect, transDir As TransitionDirection, easing As Effect.Easing, duration As Single)
		
		IncludeSource( "transitions.bas" )
		
	End Namespace

#EndIf