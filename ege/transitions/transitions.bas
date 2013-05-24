'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_TRANSITIONS_BAS__
#Define __EGE_TRANSITIONS_BAS__
	
	Dim Shared TransitionScreen	As GameScreenHandle
	
	Dim Shared newScreen		As GameScreenHandle
	
	Dim Shared oldBitmap		As Bitmap
	Dim Shared newBitmap		As Bitmap
	
	Dim Shared direction		As TransitionDirection
	
	Dim Shared TransFrameProc	As Function(fElapsed As Single) As Elite.Boolean ' return True when finished
	Dim Shared TransPaintProc	As Sub(dest As Bitmap)
	Dim Shared TransCloseProc	As Sub
	
	Dim Shared CursorVisible	As Elite.Boolean
	Dim Shared loaded			As Elite.Boolean
	
	' transition effects
	#Include "fade.bas"
	#Include "slidein.bas"
	#Include "slideout.bas"
	#Include "zoomin.bas"
	#Include "zoomout.bas"
	#Include "hstripes.bas"
	#Include "vstripes.bas"
	#Include "push.bas"
	
	
	Sub MakeTransition(transMethod As TransitionEffect, transDir As TransitionDirection, easing As Effect.Easing, duration As Single)
		
		If Not loaded Then
			
			onTransitionsLoaded.Raise TransitionScreen
			
			loaded = Elite.True
			
		EndIf
		
		CursorVisible = Engine.MouseCursorVisible
		
		Engine.HideCursor
		
		direction = transDir
		
		Select Case As Const transMethod

			Case Fade
				FadeEffect.Init easing, duration
				TransFrameProc = ProcPtr(FadeEffect.onFrame)
				TransPaintProc = ProcPtr(FadeEffect.onPaint)
				TransCloseProc = ProcPtr(FadeEffect.onClose)
				
			Case SlideIn
				SlideInEffect.Init easing, duration
				TransFrameProc = ProcPtr(SlideInEffect.onFrame)
				TransPaintProc = ProcPtr(SlideInEffect.onPaint)
				TransCloseProc = ProcPtr(SlideInEffect.onClose)
			
			Case SlideOut
				SlideOutEffect.Init easing, duration
				TransFrameProc = ProcPtr(SlideOutEffect.onFrame)
				TransPaintProc = ProcPtr(SlideOutEffect.onPaint)
				TransCloseProc = ProcPtr(SlideOutEffect.onClose)
				
			Case ZoomIn
				ZoomInEffect.Init easing, duration
				TransFrameProc = ProcPtr(ZoomInEffect.onFrame)
				TransPaintProc = ProcPtr(ZoomInEffect.onPaint)
				TransCloseProc = ProcPtr(ZoomInEffect.onClose)
				
			Case ZoomOut
				ZoomOutEffect.Init easing, duration
				TransFrameProc = ProcPtr(ZoomOutEffect.onFrame)
				TransPaintProc = ProcPtr(ZoomOutEffect.onPaint)
				TransCloseProc = ProcPtr(ZoomOutEffect.onClose)
				
			Case HorisontalStripes
				HStripesEffect.Init easing, duration
				TransFrameProc = ProcPtr(HStripesEffect.onFrame)
				TransPaintProc = ProcPtr(HStripesEffect.onPaint)
				TransCloseProc = ProcPtr(HStripesEffect.onClose)
				
			Case VerticalStripes
				VStripesEffect.Init easing, duration
				TransFrameProc = ProcPtr(VStripesEffect.onFrame)
				TransPaintProc = ProcPtr(VStripesEffect.onPaint)
				TransCloseProc = ProcPtr(VStripesEffect.onClose)
			
			Case Push
				PushEffect.Init easing, duration
				TransFrameProc = ProcPtr(PushEffect.onFrame)
				TransPaintProc = ProcPtr(PushEffect.onPaint)
				TransCloseProc = ProcPtr(PushEffect.onClose)
			
		End Select
		
		ActiveGameScreen = TransitionScreen
		
		If Not Started Then Start
		
	End Sub
	
	
	Sub Transition_onFrame(fElapsed As Single, eInputEvent As InputEvent, eventData As FB.EVENT)
		
		If TransFrameProc(fElapsed) Then
			
			oldBitmap.Destroy
			newBitmap.Destroy
			
			Dim tmp As Math.Point
			GetMouse tmp.X, tmp.Y
			SetMouse tmp.X + 1, tmp.Y + 1
			SetMouse tmp.X - 1, tmp.Y - 1
			
			If CursorVisible Then Engine.ShowCursor
						
			ActiveGameScreen = newScreen
			
			GameScreen(newScreen).onTransitionEnd.Raise
			
			Repaint

		EndIf
		
	End Sub
	
	
	Sub Transition_onPaint(dest As Bitmap)
		
		TransPaintProc(dest)
		
	End Sub
	
	
	Sub Engine_onInitialize
		
		TransitionScreen = NewGameScreen
		
		GameScreen(TransitionScreen).onFrame.Attach ProcPtr(Transition_onFrame)
		GameScreen(TransitionScreen).onPaint.Attach ProcPtr(Transition_onPaint)
		
		loaded = Elite.False
		
	End Sub
	
	Sub Engine_onDestroy
		
		If ActiveGameScreen = TransitionScreen Then
			
			TransCloseProc()
			
		EndIf
		
	End Sub
	
	Sub Transitions_Start Constructor
		
		onBeforeInitialize.Attach ProcPtr(Engine_onInitialize)
		onDestroy.Attach ProcPtr(Engine_onDestroy)
		
	End Sub
	
#EndIf