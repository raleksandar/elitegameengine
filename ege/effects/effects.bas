'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_EFFECTS_BAS__
#Define __EGE_EFFECTS_BAS__
	
	Namespace Effect

		Declare Sub Animation_onFrame(fElapsed As Single, eInputEvent As Engine.InputEvent, eventData As FB.EVENT)
		Declare Sub Engine_onStart()
		Declare Sub Engine_onDestroy()
			
		Declare Function AddAnimation(anim As Animation Pointer) As UInteger
		Declare Sub RemoveAnimation(index As UInteger)
		
		Declare Function EnumToProc(e As Easing) As EasingFunction
		Declare Function ProcToEnum(p As EasingFunction) As Easing
		
		Constructor Animation(numValues As Integer = 1, e As EasingFunction = Procptr(EasingFunc.Linear))
			
			This.iNumValues = numValues
			
			This.dStart = New Double[numValues]
			This.dEnd = New Double[numValues]
			This.dCurrent = New Double[numValues]
			This.pEasing = New EasingFunction[numValues]
			
			For i As Integer = 0 To numValues - 1
				This.pEasing[i] = e
			Next
			
			This.running = Elite.False
			This.onTarget = Elite.False
		
		End Constructor
		
		Constructor Animation(numValues As Integer, e As Easing)
			
			This.Constructor numValues, EnumToProc(e)
			
		End Constructor
		
		Constructor Animation(e As Easing)
			
			This.Constructor 1, EnumToProc(e)
		
		End Constructor
		
		Constructor Animation(e As EasingFunction)
			
			This.Constructor 1, e
		
		End Constructor
		
			
		Destructor Animation
			
			If This.running Then RemoveAnimation This.queueIndex
			
			NullDeleteArray( 	This.dStart 	)
			NullDeleteArray( 	This.dEnd		)
			NullDeleteArray( 	This.dCurrent	)
			NullDeleteArray(	This.pEasing	)
		
		End Destructor
		
		Property Animation.StartValue(newValue As Double)
			
			If IsValidPtr( This.dStart ) Then This.dStart[0] = newValue
		
		End Property
		
		Property Animation.StartValue As Double
			
			If IsValidPtr( This.dStart ) Then Return This.dStart[0]
						
			Return 0
			
		End Property
		
		Property Animation.StartValue(Index As Integer, newValue As Double)
			
			If IsValidPtr( This.dStart ) Then This.dStart[Index - 1] = newValue
		
		End Property
		
		Property Animation.StartValue(Index As Integer) As Double
			
			If IsValidPtr( This.dStart ) Then Return This.dStart[Index - 1]
			
			Return 0
			
		End Property
		
		Property Animation.EndValue(newValue As Double)
			
			If IsValidPtr( This.dEnd ) Then This.dEnd[0] = newValue
		
		End Property
		
		Property Animation.EndValue As Double
			
			If IsValidPtr( This.dEnd ) Then Return This.dEnd[0]
			
			Return 0
			
		End Property
		
		Property Animation.EndValue(Index As Integer, newValue As Double)
			
			If IsValidPtr( This.dEnd ) Then This.dEnd[Index - 1] = newValue
		
		End Property
		
		Property Animation.EndValue(Index As Integer) As Double
			
			If IsValidPtr( This.dEnd ) Then Return This.dEnd[Index - 1]
			
			Return 0
			
		End Property
		
		Property Animation.Value(newValue As Double)
			
			If IsValidPtr( This.dCurrent ) Then This.dCurrent[0] = newValue
		
		End Property
		
		Property Animation.Value As Double
			
			If IsValidPtr( This.dCurrent ) Then Return This.dCurrent[0]
			
			Return 0
			
		End Property
		
		Property Animation.Value(Index As Integer, newValue As Double)
			
			If IsValidPtr( This.dCurrent ) Then This.dCurrent[Index - 1] = newValue
		
		End Property
	
		Property Animation.Value(Index As Integer) As Double
			
			If IsValidPtr( This.dCurrent ) Then Return This.dCurrent[Index - 1]
			
			Return 0
			
		End Property
		
		Property Animation.EasingType(newValue As Easing)
			
			If IsValidPtr( This.pEasing ) Then This.pEasing[0] = EnumToProc(newValue)
		
		End Property
		
		Property Animation.EasingType As Easing
			
			If IsValidPtr( This.pEasing ) Then Return ProcToEnum(This.pEasing[0])
			
			Return Linear
			
		End Property
		
		Property Animation.EasingProc(newValue As EasingFunction)
			
			If IsValidPtr( This.pEasing ) Then This.pEasing[0] = newValue
		
		End Property
		
		Property Animation.EasingProc As EasingFunction
			
			If IsValidPtr( This.pEasing ) Then Return This.pEasing[0]
			
			Return NullPtr
			
		End Property
		
		Property Animation.EasingType(Index As Integer, newValue As Easing)
			
			If IsValidPtr( This.pEasing ) Then This.pEasing[Index - 1] = EnumToProc(newValue)
		
		End Property
	
		Property Animation.EasingType(Index As Integer) As Easing
			
			If IsValidPtr( This.pEasing ) Then Return ProcToEnum(This.pEasing[Index - 1])
			
			Return Linear
			
		End Property
		
		Property Animation.EasingProc(Index As Integer, newValue As EasingFunction)
			
			If IsValidPtr( This.pEasing ) Then This.pEasing[Index - 1] = newValue
		
		End Property
	
		Property Animation.EasingProc(Index As Integer) As EasingFunction
			
			If IsValidPtr( This.pEasing ) Then Return This.pEasing[Index - 1]
			
			Return NullPtr
			
		End Property
	
		Property Animation.TargetReached As Elite.Boolean
			
			Return This.onTarget
		
		End Property
		
		Property Animation.Playing As Elite.Boolean
			
			Return This.running
		
		End Property
		
		Property Animation.Time As Integer
			
			Return This.t
		
		End Property
	
		Sub Animation.Play(Duration As Double = 1.0)
			
			If Not IsValidPtr( This.dCurrent ) Then Exit Sub 
			
			For i As Integer = 0 To This.iNumValues - 1
				This.dCurrent[i] = This.dStart[i]
			Next
			
			This.TimeStart = Timer
			
			d = Duration
			t = 0
			
			This.onTarget = Elite.False
			This.running = Elite.True
			
			This.queueIndex = AddAnimation(VarPtr(This))
			
		End Sub
		
		Sub Animation.Stop
			
			If This.running Then 
			
				This.running = Elite.False
				RemoveAnimation This.queueIndex
								
			EndIf
						
		End Sub
		
		Sub Animation.onFrame
			
			t = Timer - TimeStart
			
			If t >= d Then
				
				t = d
				
				This.onTarget = Elite.True
				
				For i As Integer = 0 To iNumValues - 1
					
					dCurrent[i] = dEnd[i]
					
				Next
				
				RemoveAnimation This.queueIndex

			Else
				
				For i As Integer = 0 To iNumValues - 1
					
					b = dStart[i]
					c = dEnd[i] - dStart[i]
					
					dCurrent[i] = pEasing[i](t, d, b, c)
					
				Next
				
			EndIf 
			
		End Sub
		
		
		Dim Shared animList 	As Animation Pointer Pointer = NullPtr
		Dim Shared listCount 	As Integer
		Dim Shared listSize		As Integer
		Dim Shared nullPointers	As Integer = 0
		
		
		
		Function AddAnimation(anim As Animation Pointer) As UInteger
			
			Dim As Integer queueIndex
			
			If nullPointers > 0 And listCount > 0 Then
				
				For i As Integer = 0 To listCount - 1
					
					If animList[i] = NullPtr Then
						
						animList[i] = anim
						queueIndex = i
						
						Exit For
						
					EndIf
					
				Next
				
				nullPointers -= 1

			Else
						
				If listCount = listSize Then
					
					listSize += 5
					
					animList = ReAllocate(animList, listSize * SizeOf(Animation Pointer))
					
				EndIf
				
				animList[listCount] = anim
				
				queueIndex = listCount
				
				listCount += 1
			
			EndIf
			
			Return queueIndex
			
		End Function
		
		
		Sub RemoveAnimation(index As UInteger)
			
			If index >= listCount Then Exit Sub
			
			animList[index] = NullPtr
			
			nullPointers += 1
	
		End Sub
		
		
		Sub Animation_onFrame(fElapsed As Single, eInputEvent As Engine.InputEvent, eventData As FB.EVENT)
			
			If listCount > 0 Then
				
				Dim As Integer i = 0
				
				Do
					
					If IsValidPtr( animList[i] ) Then  animList[i]->onFrame
					
					i += 1
					
				Loop While i < listCount - 1
				
			EndIf
			
		End Sub
		
		
		Sub Engine_onStart()
			
			For i As Integer = 0 To Engine.ScreenCount - 1
				
				Engine.GameScreen(i).onFrame.Attach ProcPtr(Animation_onFrame)
				
			Next
			
		End Sub
		
		
		Sub Engine_onDestroy()
			
			If listCount > 0 Then
				
				For i As Integer = 0 To listCount - 1
					
					NullDelete( animList[i] )
					
				Next
				
			EndIf
			
		End Sub
		
		
		Sub Animation_Start Constructor
			
			Engine.onStart.Attach ProcPtr(Engine_onStart)
			Engine.onDestroy.Attach ProcPtr(Engine_onDestroy)
			
		End Sub
		
		Sub Animation_End Destructor
			
			If IsValidPtr( animList ) Then DeAllocate animList
			
		End Sub
		
		
		Function EnumToProc(e As Easing) As EasingFunction
			
			Select Case As Const e
				Case EaseIn:		Return ProcPtr(EasingFunc.EaseIn)
				Case EaseOut:		Return ProcPtr(EasingFunc.EaseOut)
				Case EaseInOut:		Return ProcPtr(EasingFunc.EaseInOut)
				Case ExpoIn:		Return ProcPtr(EasingFunc.ExpoIn)
				Case ExpoOut:		Return ProcPtr(EasingFunc.ExpoOut)
				Case ExpoInOut:		Return ProcPtr(EasingFunc.ExpoInOut)
				Case BounceIn:		Return ProcPtr(EasingFunc.BounceIn)
				Case BounceOut:		Return ProcPtr(EasingFunc.BounceOut)
				Case BounceInOut:	Return ProcPtr(EasingFunc.BounceInOut)
				Case ElasIn:		Return ProcPtr(EasingFunc.ElasIn)
				Case ElasOut:		Return ProcPtr(EasingFunc.ElasOut)
				Case ElasInOut:		Return ProcPtr(EasingFunc.ElasInOut)
				Case BackIn:		Return ProcPtr(EasingFunc.BackIn)
				Case BackOut:		Return ProcPtr(EasingFunc.BackOut)
				Case BackInOut:		Return ProcPtr(EasingFunc.BackInOut)
				Case CubicIn:		Return ProcPtr(EasingFunc.CubicIn)
				Case CubicOut:		Return ProcPtr(EasingFunc.CubicOut)
				Case CubicInOut:	Return ProcPtr(EasingFunc.CubicInOut)
				Case CircIn:		Return ProcPtr(EasingFunc.CircIn)
				Case CircOut:		Return ProcPtr(EasingFunc.CircOut)
				Case CircInOut:		Return ProcPtr(EasingFunc.CircInOut)
				Case SineIn:		Return ProcPtr(EasingFunc.SineIn)
				Case SineOut:		Return ProcPtr(EasingFunc.SineOut)
				Case SineInOut:		Return ProcPtr(EasingFunc.SineInOut)
			End Select
			
			Return ProcPtr(EasingFunc.Linear)
			
		End Function
		
		
		Function ProcToEnum(p As EasingFunction) As Easing
			
			Select Case p
				Case ProcPtr(EasingFunc.EaseIn): 			Return EaseIn
				Case ProcPtr(EasingFunc.EaseOut): 			Return EaseOut
				Case ProcPtr(EasingFunc.EaseInOut): 		Return EaseInOut
				Case ProcPtr(EasingFunc.ExpoIn): 			Return ExpoIn
				Case ProcPtr(EasingFunc.ExpoOut): 			Return ExpoOut
				Case ProcPtr(EasingFunc.ExpoInOut): 		Return ExpoInOut
				Case ProcPtr(EasingFunc.BounceIn): 			Return BounceIn
				Case ProcPtr(EasingFunc.BounceOut): 		Return BounceOut
				Case ProcPtr(EasingFunc.BounceInOut): 		Return BounceInOut
				Case ProcPtr(EasingFunc.ElasIn): 			Return ElasIn
				Case ProcPtr(EasingFunc.ElasOut): 			Return ElasOut
				Case ProcPtr(EasingFunc.ElasInOut): 		Return ElasInOut
				Case ProcPtr(EasingFunc.BackIn): 			Return BackIn
				Case ProcPtr(EasingFunc.BackOut): 			Return BackOut
				Case ProcPtr(EasingFunc.BackInOut): 		Return BackInOut
				Case ProcPtr(EasingFunc.CubicIn): 			Return CubicIn
				Case ProcPtr(EasingFunc.CubicOut): 			Return CubicOut
				Case ProcPtr(EasingFunc.CubicInOut): 		Return CubicInOut
				Case ProcPtr(EasingFunc.CircIn): 			Return CircIn
				Case ProcPtr(EasingFunc.CircOut): 			Return CircOut
				Case ProcPtr(EasingFunc.CircInOut): 		Return CircInOut
				Case ProcPtr(EasingFunc.SineIn): 			Return SineIn
				Case ProcPtr(EasingFunc.SineOut): 			Return SineOut
				Case ProcPtr(EasingFunc.SineInOut): 		Return SineInOut
			End Select
			
			Return Linear
			
		End Function
	
	End Namespace
	
	
#EndIf