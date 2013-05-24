'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
#Ifndef __EGE_ENGINE_BAS__
#Define __EGE_ENGINE_BAS__
	

	'{ declare variables
		
	Dim Shared As Elite.Boolean			Initialized = Elite.False				' current engine state
	Dim Shared As Bitmap Pointer		MouseCursorBitmap  = NullPtr			' mouse cursor bitmap
	Dim Shared As Point					MouseCursorHotspot						' mouse cursor hotspot
	Dim Shared As Point					MouseCursorPosition						' current position of mouse cursor
	Dim Shared As Elite.Boolean			MouseCursorInsideWindow = Elite.False	' is mouse window over window? 

	Dim Shared As Elite.Boolean			GameLoopRunning = Elite.False			' is the game loop running?

	Dim Shared As Elite.Boolean			RepaintNeeded = Elite.False				' repaint flag
	
	'} 	
	
	
	'{ implement types
	
	Operator Resolution.Cast As String
		
		Return Str(This.Width) & "x" & Str(This.Height) & "x" & Str(This.Depth)
		
	End Operator
	
	
	Sub ResolutionList.Add(w As Integer, h As Integer, d As Integer)
		
		This.Count += 1
		
		This.List = ReAllocate(This.List, This.Count * SizeOf(Resolution))
		
		This.List[This.Count - 1] = Type<Resolution>(w, h, d)
		
	End Sub
	
	
	Sub GameTimer.Start
		
		If This.Interval > 0 Then
			
			This.elapsed = 0
			This.state = 1
			
		EndIf
		
	End Sub
	
	Sub GameTimer.Pause
		
		This.state = 2
		
	End Sub
	
	Sub GameTimer.Stop
		
		This.state = 0
		
	End Sub
	
	Sub GameTimer.onFrame(fElapsed As Single)
		
		If This.state = 1 Then

			This.elapsed += fElapsed
			
			If This.elapsed >= This.Interval Then
				
				This.elapsed = 0
				This.onInterval.Raise
				
			EndIf		
			
		EndIf
		
	End Sub
	
	'}
	
	
	'{ implement methods

	
	' initializes engine to specified window mode
	'	res - Engine.Resolution value
	'	w - width (in pixels)
	'	h - height (in pixels)
	'	fs - windowed (False) or fullscreen (True) mode
	'	flags - additional ScreenRes flags
	'	returns Elite.False if failed to set video mode		
	Function Initialize(res As Resolution, fs As Elite.Boolean = Elite.False, flags As Integer = 0) As Elite.Boolean
		
		Return Initialize(res.Width, res.Height, fs, flags)

	End Function

	Function Initialize(w As Integer, h As Integer, fs As Elite.Boolean = Elite.False, flags As Integer = 0) As Elite.Boolean
		
		If Not Initialized Then

			ScreenRes w, h, 32, 1, IIf(fs, FB.GFX_FULLSCREEN, FB.GFX_WINDOWED) Or flags
			
			If ScreenPtr = 0 Then

				Return Elite.False			' Failed to set video mode

			EndIf
			
			System.SetWindowIcon			' set window's icon
			
			ScreenResolution = Type<Resolution>(w, h, 32)
			
			HideCursor						' hide mouse cursor
			
			Randomize Timer					' seed random number generator

			Initialized = Elite.True		' set the initialized flag
			
			onBeforeInitialize.Raise
			
			onInitialize.Raise 				' engine ready, lets fireup the game!

		EndIf

		Return Elite.True

	End Function
	
	
	' creates new game screen, returns screen's handle
	Function NewGameScreen As GameScreenHandle
		
		ReDim Preserve GameScreen(0 To ScreenCount)
		
		Function = ScreenCount
		
		ScreenCount += 1
		
	End Function
	
	
	' shows game screen and sets that screen as active (performs transition effect if one is chosen)
	Sub Show(scr As GameScreenHandle, transMethod As TransitionEffect = TransitionEffect.None, transDir As TransitionDirection = TransitionDirection.FromLeft, easing As Effect.Easing = Effect.Linear, duration As Single = 0.8)
		
		Assert( scr > IllegalScreenHandle And scr < ScreenCount )
		
		Dim As Integer firstScreen = ActiveGameScreen = IllegalScreenHandle
		
		If Not GameScreen(scr).loaded Then
			
			GameScreen(scr).loaded = Elite.True
			GameScreen(scr).onLoad.Raise
			
		EndIf
		
		GameScreen(scr).onShow.Raise
		
		If transMethod <> TransitionEffect.None Then
			
			Transition.oldBitmap.Create ScreenResolution.Width, ScreenResolution.Height, Color.Black
			Transition.newBitmap.Create ScreenResolution.Width, ScreenResolution.Height, Color.Black
			
			Assert( Transition.oldBitmap.Handle <> 0 )
			Assert( Transition.newBitmap.Handle <> 0 )
			
			If Not firstScreen Then
				
				GameScreen(ActiveGameScreen).onPaint.Raise Transition.oldBitmap
				
				Dim As Elite.Boolean Cancel = Elite.False
			
				GameScreen(ActiveGameScreen).onHide.Raise scr, Cancel
				
				If Cancel Then Exit Sub
				
			EndIf
			
			GameScreen(scr).onPaint.Raise Transition.newBitmap
			
			Transition.newScreen = scr
			
			Transition.MakeTransition transMethod, transDir, easing, duration
		
		Else
			
			If Not firstScreen Then
			
				Dim As Elite.Boolean Cancel = Elite.False
			
				GameScreen(ActiveGameScreen).onHide.Raise scr, Cancel
				
				If Cancel Then Exit Sub
							
			EndIf
			
			ActiveGameScreen = scr
			
			Repaint
			
			' generate MouseMove event
			Dim tmp As Math.Point
			GetMouse tmp.X, tmp.Y
			SetMouse tmp.X + 1, tmp.Y + 1
			SetMouse tmp.X - 1, tmp.Y - 1
		
			If Not Started Then Start	
		
		EndIf

	End Sub
	
	
	' show mouse cursor
	Sub ShowCursor
		
		MouseCursorVisible = Elite.True
		
		If MouseCursorBitmap = SystemCursor Then
			
			GetMouse MouseCursorPosition.X, MouseCursorPosition.Y
			
			SetMouse MouseCursorPosition.X, MouseCursorPosition.Y, 1 
			
		EndIf
		 
	End Sub
	
	' hide mouse cursor
	Sub HideCursor
		
		MouseCursorVisible = Elite.False
		
		If MouseCursorBitmap = SystemCursor Then
			
			GetMouse MouseCursorPosition.X, MouseCursorPosition.Y
			
			SetMouse MouseCursorPosition.X, MouseCursorPosition.Y, 0 
			
		EndIf			
		
	End Sub
	
	' sets bitmap to use as mouse cursor (or resets to system cursor)
	Sub SetCursor(cursor As Bitmap Pointer, X As Integer = 0, Y As Integer = 0)
		
		MouseCursorBitmap = cursor
		
		If cursor <> SystemCursor Then
			MouseCursorHotspot = Type<Point>(X, Y)
		Else
			MouseCursorHotspot = Type<Point>(0, 0)
		EndIf
		
	End Sub	
	
	' return true if mouse is over non-transparent area of bitmap
	Function MouseOverObject(obj As Bitmap, rect As Math.Rect, mode As TestType = AlphaValue, value As UInteger = 100) As Elite.Boolean
		
		Assert( IsValidPtr( obj.Handle ) )
		
		Dim mouse As Point = MouseCursorPosition
		
		mouse.X += MouseCursorHotspot.X
		mouse.Y += MouseCursorHotspot.Y
				
		If mouse.X >= rect.X And mouse.X <= rect.X + rect.W And _
		   mouse.Y >= rect.Y And mouse.Y <= rect.Y + rect.H Then
			
			If mode = AlphaValue Then
				
				Return obj.PixelAlpha(Type<Point>(mouse.X - rect.X, mouse.Y - rect.Y)) > value
			
			Else
				
				Return obj.Pixel(Type<Point>(mouse.X - rect.X, mouse.Y - rect.Y)) <> value  
			
			EndIf
		  
		EndIf
		
		Return Elite.False
		
	End Function
	
	' called when screen has to be repainted
	Sub Repaint
		
		RepaintNeeded = Elite.True
		
	End Sub
	
	
	' starts game loop
	Sub Start
		
		Assert( Started = Elite.False )
		Assert( ActiveGameScreen > IllegalScreenHandle And ActiveGameScreen < ScreenCount )
		
		Dim As Graphics.Bitmap		screenBitmap
		Dim As Double				fElapsed
		Dim As Double				fTimer = Timer
		Dim As FB.EVENT				systemEvent
		Dim As Engine.InputEvent	eInputEvent
	
		' TODO: replace ENGINE_LIMIT_FPS #define with variable	
		#Ifdef ENGINE_LIMIT_FPS
		Dim As Integer				sleepInterval
		#EndIf
		
		Started = Elite.True			' we are about to start running the game!
		
		onStart.Raise					' raise Engine.onStart event
		
		GameLoopRunning = Elite.True	' set the running flag
		
		'screenBitmap.Create ScreenResolution.Width, ScreenResolution.Height, Color.Black
		
		ScreenLock
		
		Do
			fElapsed = Timer - fTimer				' how much seconds passed since last frame
			fTimer = Timer
			
			' process events
			If ScreenEvent(VarPtr(systemEvent)) Then
				
				If Not (systemEvent.Type < InputEvent.MouseButtonDoubleClick Or systemEvent.Type = InputEvent.MouseHWHeel) Then
				
					' "system" event (not an input event)
					Select Case systemEvent.Type
						
						' mouse enters window's area
						Case FB.EVENT_MOUSE_ENTER
							
							onMouseEnter.Raise
							
							MouseCursorInsideWindow = Elite.True
							
						
						' mouse leaves window's area
						Case FB.EVENT_MOUSE_EXIT
							
							onMouseLeave.Raise
							
							MouseCursorInsideWindow = Elite.False
							
							' repaint
							If MouseCursorVisible And MouseCursorBitmap <> SystemCursor Then		
								
								RepaintNeeded = Elite.True
								
								MouseCursorPosition = Type<Point>(systemEvent.X, systemEvent.Y)
								
							EndIf						
							
						
						' window gets focus
						Case FB.EVENT_WINDOW_GOT_FOCUS: onFocus.Raise
							
						' window loses focus
						Case FB.EVENT_WINDOW_LOST_FOCUS: onBlur.Raise
							
						' user attempts to close window
						Case FB.EVENT_WINDOW_CLOSE: Shutdown
						
					End Select
					
					eInputEvent = InputEvent.None	' not an input event
				
				Else
				
					eInputEvent = systemEvent.Type ' keyboard or mouse event
					  						
					If eInputEvent = MouseMove Then
						
						MouseCursorPosition = Type<Point>(systemEvent.X, systemEvent.Y)
						
						If MouseCursorVisible And MouseCursorBitmap <> SystemCursor Then
							
							RepaintNeeded = Elite.True
							
						EndIf
						
					EndIf
				
				EndIf
				 
			Else
				
				eInputEvent = InputEvent.None ' no event
				
			EndIf
			
			' do game logic
			GameScreen(ActiveGameScreen).onFrame.Raise fElapsed, eInputEvent, systemEvent
			
			
			' repaint if needed
			If RepaintNeeded Then
				
				GameScreen(ActiveGameScreen).onPaint.Raise screenBitmap
				
				' draw cursor if custom and visible
				If (eInputEvent = MouseMove Or eInputEvent = InputEvent.None) And _
					MouseCursorVisible And MouseCursorBitmap <> SystemCursor And _
					MouseCursorInsideWindow = Elite.True Then
					
					MouseCursorBitmap->DrawTo 0, MouseCursorPosition.X + MouseCursorHotspot.X, MouseCursorPosition.Y + MouseCursorHotspot.Y

				EndIf
				
				RepaintNeeded = Elite.False
				
			EndIf
			
			
			ScreenUnLock
				
				' limit fps if said to do so
				#Ifdef ENGINE_LIMIT_FPS
					
					sleepInterval = CInt((fTimer + 1.0 / ENGINE_LIMIT_FPS - Timer) * 1000.0)
					
					If sleepInterval < 1 Then sleepInterval = 1
					
					Sleep sleepInterval, 1
				
				#Else
			
					Sleep 1, 1	' keep CPU usage at minimum level
				
				#EndIf
			
			ScreenLock
			
		Loop While GameLoopRunning
		
		ScreenUnLock
		
		
		GameScreen(ActiveGameScreen).onHide.Raise IllegalScreenHandle
		
		onDestroy.Raise
		
	End Sub
	
	
	' call this if you want to exit from application (game)
	' if you set Force to Elite.True then handlers will not be allowed to cancel shutdown process
	' returns Elite.False if shutdown was canceled 
	Function Shutdown(Force As Elite.Boolean = Elite.False, RaiseEvent As Elite.Boolean = Elite.True) As Elite.Boolean
		
		Dim As Elite.Boolean Cancel = Elite.False
		
		If RaiseEvent Then onShutdown.Raise Cancel		' raise Engine.onShutdown
		
		If Not Force And Cancel Then
			
			Return Elite.False							' shutdown canceled
			
		EndIf
		
		' raise active screen's onHide event
		If ActiveGameScreen > IllegalScreenHandle And RaiseEvent Then
			
			GameScreen(ActiveGameScreen).onHide.Raise IllegalScreenHandle
				
		EndIf
		
		onDestroy.Raise									' raise Engine.onDestroy
		
		GameLoopRunning = Elite.False					' stops game loop
		
		System.Terminate
			
	End Function
	
	
	' returns available fullscreen video modes (modes are returned from lowest to highest supported)
	Function SupportedResolutions(depth As Integer = 32) As ResolutionList
		
		Dim As Integer 			mode
		Dim As ResolutionList	list
		
		mode = ScreenList(depth)
		
		While mode
			
			list.Add HiWord(mode), LoWord(mode), depth
			
			mode = ScreenList
			
		Wend
		
		Return list
		
	End Function
	
	'}

#EndIf