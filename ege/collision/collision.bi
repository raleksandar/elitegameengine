'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_COLLISION_BI__
#Define __EGE_COLLISION_BI__
	
	Declare Function Collides OverLoad(box1 As Rect, box2 As Rect) As Elite.Boolean
	Declare Function Collides(b1 As RectF, b2 As RectF) As Elite.Boolean
	
	
	IncludeSource( "collision.bas" )

#EndIf