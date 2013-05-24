'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_TRANSITIONS_VSTRIPES_BAS__
#Define __EGE_TRANSITIONS_VSTRIPES_BAS__
	
	Namespace VStripesEffect
		
		
		Dim Shared As Effect.Animation Pointer anim
		Dim Shared As Integer numStripes 
		
		
		Sub Init(easing As Effect.Easing, duration As Single)
			
			numStripes = newBitmap.Width \ 10 - (newBitmap.Width Mod 10 <> 0)
			
			anim = New Effect.Animation(easing)
			
			anim->StartValue = -CDbl(newBitmap.Height)
			anim->EndValue = 0

			
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
			
			oldBitmap.DrawTo dest
			
			For i As Integer = 0 To numStripes - 1
				
				If i Mod 2 Then
					
					Put dest, (i * 10, anim->Value), newBitmap.Handle, (i * 10, 0) - Step (10, newBitmap.Height), PSet
				
				Else
					
					Put dest, (i * 10, -anim->Value), newBitmap.Handle, (i * 10, 0) - Step (10, newBitmap.Height), PSet
					
				EndIf
				
			Next
			
		End Sub
		
		Sub onClose
			
			If IsValidPtr( anim ) Then anim->Stop
			
			NullDelete( anim )
			
		End Sub
		
	End Namespace

#EndIf