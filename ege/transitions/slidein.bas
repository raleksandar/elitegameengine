'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_TRANSITIONS_SLIDEIN_BAS__
#Define __EGE_TRANSITIONS_SLIDEIN_BAS__
	
	Namespace SlideInEffect
		
		
		Dim Shared As Effect.Animation Pointer anim 
		
		
		Sub Init(easing As Effect.Easing, duration As Single)
			
			anim = New Effect.Animation(2, easing)
			
			anim->StartValue(1) = 0
			anim->StartValue(2) = 0
			
			anim->EndValue(1) = 0
			anim->EndValue(2) = 0
			
			Select Case direction
				
				Case FromLeft
					anim->StartValue(1) = -CDbl(newBitmap.Width)
					
				Case FromRight
					anim->StartValue(1) = CDbl(newBitmap.Width)
				
				Case FromTop
					anim->StartValue(2) = -CDbl(newBitmap.Height)
				
				Case FromBottom
					anim->StartValue(2) = CDbl(newBitmap.Height)
				
				Case FromTopLeft
					anim->StartValue(1) = -CDbl(newBitmap.Width)
					anim->StartValue(2) = -CDbl(newBitmap.Height)
				
				Case FromTopRight
					anim->StartValue(1) = CDbl(newBitmap.Width)
					anim->StartValue(2) = -CDbl(newBitmap.Height)
				
				Case FromBottomLeft
					anim->StartValue(1) = -CDbl(newBitmap.Width)
					anim->StartValue(2) = CDbl(newBitmap.Height)
				
				Case FromBottomRight
					anim->StartValue(1) = CDbl(newBitmap.Width)
					anim->StartValue(2) = CDbl(newBitmap.Height)
				
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
			
			oldBitmap.DrawTo dest, , , , , , , fbPSet
			newBitmap.DrawTo dest, anim->Value(1), anim->Value(2), , , , , fbPSet
			
		End Sub
		
		Sub onClose
			
			If IsValidPtr( anim ) Then anim->Stop
			
			NullDelete( anim )
			
		End Sub
		
	End Namespace
	
#EndIf