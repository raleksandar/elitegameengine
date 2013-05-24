
'#Define ENGINE_LIMIT_FPS 60

#Include "../ege.bi"		' import EGE source 

Using Elite					' we use Elite Namespace


' first we declare our starting point (the Engine.onInitialize event handler)
Declare Sub Game_onInitialize


' in module constructor we attach onInitialize event handler
Sub Module Constructor
	
	Engine.onInitialize.Attach ProcPtr(Game_onInitialize)
	
End Sub


' now we declare game screens

Dim Shared As Engine.GameScreenHandle	MainScreen


' and their event handlers:

Declare Sub MainScreen_onShow
Declare Sub MainScreen_onFrame(fElapsed As Single, eInputEvent As Engine.InputEvent, eventData As FB.EVENT)
Declare Sub MainScreen_onPaint(dest As Engine.Bitmap)

' declare shared variables (bitmaps and stuff) and types we need

Type Ball
	rect		As Math.Rect
	image		As Graphics.Bitmap
	hovered		As Elite.Boolean
	dragging	As Elite.Boolean
	velocity	As Math.PointF
End Type

Dim Shared As Graphics.Bitmap bmpCursor 
Dim Shared As Graphics.Bitmap bmpBackground

Dim Shared As Ball theBall

Dim Shared As Single gravity = 20
Dim Shared As Single restitution = 0.7
Dim Shared As Single friction = 0.9



' now we implement those handlers

' gets called when screen is shown
Sub MainScreen_onShow
	
	bmpCursor.LoadFromFile("images/cursor.png")			' load cursor bitmap
	bmpBackground.LoadFromFile("images/background.png")	' load background bitmap
	
	theBall.image.LoadFromFile("images/ball.png")		' load ball bitmap
	
	Dim As Color.RGBTriple Pointer tmp = New Color.RGBTriple(-30, 60, -30)
	
	theBall.image.ApplyFilter Graphics.fbGrayscale
	theBall.image.ApplyFilter Graphics.fbColorOffset, tmp
	
	Delete tmp
	
	'theBall.image.Resize 200, 200, Graphics.fbScaleBilinear
	
	theBall.image.PreserveAlphaChannel  	' preserve alpha channel so we can use .Alpha without any loss 
	theBall.image.Alpha = 205				' set alpha to 80%
	
	theBall.hovered = False
	
	' move ball to top middle of the screen:
	theBall.rect.x = (Engine.ScreenResolution.Width - theBall.image.Width) / 2
	theBall.rect.y = 0
	theBall.rect.w = theBall.image.Width - 7 	' shadow takes approx 9px
	theBall.rect.h = theBall.image.Height - 9

	Engine.SetCursor VarPtr(bmpCursor), 5, 5			' set custom cursor bitmap
	Engine.ShowCursor									' show mouse cursor (default is hidden)	
	
End Sub

' gets called on each frame
Sub MainScreen_onFrame(fElapsed As Single, eInputEvent As Engine.InputEvent, eventData As FB.EVENT)
	
	If eInputEvent = Engine.KeyPress Then					' key was pressed
		
		If eventData.scanCode = Engine.KeyEscape Then Engine.Shutdown
	
	
	ElseIf eInputEvent = Engine.MouseMove Then				' mouse has moved
		
		If theBall.dragging Then
			
			' move ball
			theBall.rect.X += eventData.dX
			theBall.rect.Y += eventData.dY
			
			' change it's velocity
			theBall.velocity.X = eventData.dX * 2
			theBall.velocity.Y = eventData.dY * 2 
			
			' check if it leaves screen and adjust coords
			If theBall.rect.X < 0 Then
				
				theBall.rect.X = 0
				
			ElseIf theBall.rect.X + theBall.rect.W > Engine.ScreenResolution.Width Then
				
				theBall.rect.X = Engine.ScreenResolution.Width - theBall.rect.W
				
			EndIf
			
			If theBall.rect.Y < 0 Then
				
				theBall.rect.Y = 0
				
			ElseIf theBall.rect.Y + theBall.rect.H > Engine.ScreenResolution.Height Then
				
				theBall.rect.Y = Engine.ScreenResolution.Height - theBall.rect.H
				
			EndIf
			
			Engine.Repaint		' redraw entire screen
			
			
		ElseIf Engine.MouseOverObject(theBall.image, theBall.rect) Then
				
			If Not theBall.hovered Then

				theBall.hovered = True
				theBall.image.Alpha = 255
				
				Engine.Repaint	' redraw entire screen			
				
			EndIf
							
		Else
				
			If theBall.hovered Then
				
				theBall.hovered = False
				theBall.image.Alpha = 205
				
				Engine.Repaint	' redraw entire screen
				
			EndIf			
			
		EndIf
			
	
	ElseIf eInputEvent = Engine.MouseButtonPress Then		' mouse button was pressed
		
		If eventData.button = Engine.LeftButton Then		' it's left button
			
			If theBall.hovered Then
				
				theBall.dragging = True	' start dragging ball!
				
			EndIf
			
		EndIf
	
	
	ElseIf eInputEvent = Engine.MouseButtonRelease Then		' mouse button was released
		
		If eventData.button = Engine.LeftButton Then		' it's left button
			
			theBall.dragging = False  	' stop dragging ball!
			
		EndIf
	
	EndIf
	
	If Not theBall.dragging And (theBall.rect.Y + theBall.rect.H < Engine.ScreenResolution.Width Or theBall.velocity.Y > 0 Or theBall.velocity.X > 0) Then
		
		theBall.velocity.Y += gravity
		
		theBall.rect.Y += theBall.velocity.Y * fElapsed
		theBall.rect.X += theBall.velocity.X * fElapsed
		
		If theBall.rect.Y + theBall.rect.H > Engine.ScreenResolution.Height Then
			
			theBall.rect.Y = Engine.ScreenResolution.Height - theBall.rect.H
			
			theBall.velocity.Y *= -restitution
			
			theBall.velocity.X *= friction
			
		EndIf
		
		If theBall.rect.X < 0 Then
				
			theBall.rect.X = 0
			
			theBall.velocity.X *= -restitution * 2
			
		ElseIf theBall.rect.X + theBall.rect.W > Engine.ScreenResolution.Width Then
			
			theBall.rect.X = Engine.ScreenResolution.Width - theBall.rect.W
			
			theBall.velocity.X *= -restitution * 2
			
		EndIf
		
		Engine.Repaint
		
	EndIf
	
End Sub

' gets called when we need to do some drawing
Sub MainScreen_onPaint(dest As Engine.Bitmap)
	
	' first draw background 
	bmpBackground.DrawTo dest
	
	' then the ball
	theBall.image.DrawTo dest, theBall.rect.X, theBall.rect.Y
		
End Sub



' now we implement onInitialize event handler
Sub Game_onInitialize
	
	MainScreen = Engine.NewGameScreen	' create new screen
	
	' attach it's event handlers
	
	Engine.GameScreen(MainScreen).onShow.Attach ProcPtr(MainScreen_onShow)
	Engine.GameScreen(MainScreen).onFrame.Attach ProcPtr(MainScreen_onFrame)
	Engine.GameScreen(MainScreen).onPaint.Attach ProcPtr(MainScreen_onPaint)
	
	'Engine.Show MainScreen, Engine.SlideIn, Engine.FromBottomRight, Effect.ElasOut, 2
	Engine.Show MainScreen, Engine.HorisontalStripes, , Effect.BackOut
	' uncomment first Engine.Show line to see some "dizzy" effect :)  (offcourse comment second one)
	
	' hint: 
	'	Engine.Show will also call Engine.Start if this is first screen we're Showing
	'	and Engine.Start should never be called directly
		
End Sub

	' set title for our game window
	WindowTitle "EliteGameEngine demo"

	' and finaly we can start the game!
	Engine.Initialize 640, 480, False, FB.GFX_NO_SWITCH	' 640x480, windowed, disable fullscreen switch


	End 1  ' be sure to exit :)
