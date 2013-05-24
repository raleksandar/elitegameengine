'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_TRANSITIONS_SLIDEOUT_BAS__
#Define __EGE_TRANSITIONS_SLIDEOUT_BAS__
	
	Namespace SlideOutEffect
		
		
		Dim Shared As Effect.Animation Pointer anim 
		
		
		Sub Init(easing As Effect.Easing, duration As Single)
			
			anim = New Effect.Animation(2, easing)
			
			anim->StartValue(1) = 0
			anim->StartValue(2) = 0
			
			anim->EndValue(1) = 0
			anim->EndValue(2) = 0
			
			Select Case direction
				
				Case FromLeft
					anim->EndValue(1) = CDbl(oldBitmap.Width)
					
				Case FromRight
					anim->EndValue(1) = -CDbl(oldBitmap.Width)
				
				Case FromTop
					anim->EndValue(2) = CDbl(oldBitmap.Height)
				
				Case FromBottom
					anim->EndValue(2) = -CDbl(oldBitmap.Height)
				
				Case FromTopLeft
					anim->EndValue(1) = CDbl(oldBitmap.Width)
					anim->EndValue(2) = CDbl(oldBitmap.Height)
				
				Case FromTopRight
					anim->EndValue(1) = -CDbl(oldBitmap.Width)
					anim->EndValue(2) = CDbl(oldBitmap.Height)
				
				Case FromBottomLeft
					anim->EndValue(1) = CDbl(oldBitmap.Width)
					anim->EndValue(2) = -CDbl(oldBitmap.Height)
				
				Case FromBottomRight
					anim->EndValue(1) = -CDbl(oldBitmap.Width)
					anim->EndValue(2) = -CDbl(oldBitmap.Height)
				
			End Select
			
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
			
			newBitmap.DrawTo dest, , , , , , , fbPSet
			oldBitmap.DrawTo dest, anim->Value(1), anim->Value(2), , , , , fbPSet
			
		End Sub
		
		Sub onClose
			
			If IsValidPtr( anim ) Then anim->Stop
			
			NullDelete( anim )
			
		End Sub
		
	End Namespace
	
#EndIf