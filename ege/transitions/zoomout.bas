'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_TRANSITIONS_ZOOMOUT_BAS__
#Define __EGE_TRANSITIONS_ZOOMOUT_BAS__
	
	Namespace ZoomOutEffect
		
		
		Dim Shared As Effect.Animation Pointer anim 
		
		
		Sub Init(easing As Effect.Easing, duration As Single)
			
			anim = New Effect.Animation(4, easing)
			
			anim->StartValue(1) = 0
			anim->StartValue(2) = 0
			anim->StartValue(3) = oldBitmap.Width
			anim->StartValue(4) = oldBitmap.Height
			
			anim->EndValue(1) = newBitmap.Width / 2 - 1
			anim->EndValue(2) = newBitmap.Height / 2 - 1
			anim->EndValue(3) = 2
			anim->EndValue(4) = 2
			
			anim->Play duration
				
		End Sub
		
		
		Function onFrame(fElapsed As Single) As Elite.Boolean
			
			If Not IsValidPtr( anim ) Then Return Elite.True
			
			Repaint
			
			If anim->TargetReached Then
				
				NullDelete( anim )
				
				Return Elite.True
				
			EndIf
			
			Return Elite.False
			
		End Function
		
		
		Sub onPaint(dest As Bitmap)
			
			newBitmap.DrawTo dest
			
			' TODO: optimize this, it's too slow!
			
			Dim As Double factorX = newBitmap.Width / Math.Max(anim->Value(3), 0.01)
			Dim As Double factorY = newBitmap.Height / Math.Max(anim->Value(4), 0.01)
			
			For X As Integer = 0 To anim->Value(3) - 1
				For Y As Integer = 0 To anim->Value(4) - 1
					
					Put dest, (anim->Value(1) + X, anim->Value(2) + Y), oldBitmap.Handle, (Int(X * factorX), Int(Y * factorY)) - Step (1,1), PSet
					
				Next
			Next
			
		End Sub
		
		Sub onClose
			
			If IsValidPtr( anim ) Then anim->Stop
			
			NullDelete( anim )
			
		End Sub
		
	End Namespace
	
#EndIf