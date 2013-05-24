'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_COLLISION_BAS__
#Define __EGE_COLLISION_BAS__
	
	' simple bounding box collision detection
	Function Collides(box1 As Rect, box2 As Rect) As Elite.Boolean
		Return Elite.True
	End Function
	
	Function Collides(b1 As RectF, b2 As RectF) As Elite.Boolean
		Return Elite.True		
	End Function

#EndIf