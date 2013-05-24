
' implementation of first screen

Namespace Screen4
	
	
	' here we create the screen and attach it's event handlers
	Sub Game_onInitialize
		
		GameScreen = Engine.NewGameScreen
		
		Engine.GameScreen(GameScreen).onShow.Attach  ProcPtr(Screen_onShow)
		Engine.GameScreen(GameScreen).onHide.Attach  ProcPtr(Screen_onHide)
		Engine.GameScreen(GameScreen).onFrame.Attach ProcPtr(Screen_onFrame)
		Engine.GameScreen(GameScreen).onPaint.Attach ProcPtr(Screen_onPaint)
		
	End Sub
	
	
	' called when screen is about to be shown - here we initialize our variables
	Sub Screen_onShow
		
		background.LoadFromFile "images/background4.png"
		
		nextScreen.Create Color.DarkOrange
		nextScreen.rect.X = Engine.ScreenResolution.Width - nextScreen.rect.W - 50
		nextScreen.rect.Y = (Engine.ScreenResolution.Height - nextScreen.rect.H) / 2
		nextScreen.image.Alpha = 200
		
		prevScreen.Create Color.DarkOrange, Elite.True
		prevScreen.rect.X = 50
		prevScreen.rect.Y = (Engine.ScreenResolution.Height - prevScreen.rect.H) / 2
		prevScreen.image.Alpha = 200
		
		title.Font = bmpFont
		title.X = 0
		title.Y = 40
		title.Size Engine.ScreenResolution.Width, 100
		title.Align = UI.AlignMiddleCenter
		title.Text = "Screen 4/4"
		
	End Sub
	
	' called when screen is about to be hidden - here we destroy any bitmaps we have loaded	
	Sub Screen_onHide(newScreen As Engine.GameScreenHandle, ByRef Cancel As Elite.Boolean = Elite.False)
		
		' acctualy, destroying bitmaps is not necesary but we should play nice
		' and use only as much memory as we need at that moment
		
		background.Destroy
		prevScreen.Destroy
		nextScreen.Destroy
		
	End Sub
	
	' called once per game frame - all our game logic goes here 
	Sub Screen_onFrame(fElapsed As Single, eInputEvent As Engine.InputEvent, eventData As FB.EVENT)
		
		If eInputEvent = Engine.KeyPress Then					' key was pressed
		
			Select Case As Const eventData.scanCode
				
				Case Engine.KeyEscape: 		Engine.Shutdown
				
				Case Engine.KeySpace:		ShowScreen Screen1.GameScreen
					
				Case Engine.KeyBackSpace:	ShowScreen Screen3.GameScreen
				
			End Select
		
		
		ElseIf eInputEvent = Engine.MouseMove Then				' mouse has moved
			
			If Engine.MouseOverObject(nextScreen.image, nextScreen.rect) Then
				
				If Not nextScreen.hovered Then
					
					nextScreen.hovered = Elite.True
					nextScreen.image.Alpha = 255
					
					Engine.Repaint
					
				EndIf
				
			ElseIf Engine.MouseOverObject(prevScreen.image, prevScreen.rect) Then
				
				If Not prevScreen.hovered Then
					
					prevScreen.hovered = Elite.True
					prevScreen.image.Alpha = 255
					
					Engine.Repaint
					
				EndIf
			
			Else
				
				If nextScreen.Hovered Then
					
					nextScreen.Hovered = Elite.False
					nextScreen.image.Alpha = 200
					
					Engine.Repaint
				
				ElseIf prevScreen.Hovered Then
					
					prevScreen.Hovered = Elite.False
					prevScreen.image.Alpha = 200
					
					Engine.Repaint
					
				EndIf
							
			EndIf
		
		ElseIf eInputEvent = Engine.MouseButtonPress Then		' mouse button was pressed
			
			prevScreen.Pressed = prevScreen.Hovered
			nextScreen.Pressed = nextScreen.Hovered
		
		ElseIf eInputEvent = Engine.MouseButtonRelease Then		' mouse button was released
			
			If prevScreen.Pressed Then
				
				prevScreen.Pressed = False
				
				If prevScreen.Hovered Then ShowScreen Screen3.GameScreen
			
			ElseIf nextScreen.Pressed Then
				
				nextScreen.Pressed = False
				
				If nextScreen.Hovered Then ShowScreen Screen1.GameScreen
					
			EndIf
		
		EndIf
		
	End Sub
	
	' called when screen needs to be repainted
	Sub Screen_onPaint(dest As Engine.Bitmap)
		
		background.DrawTo dest
		
		title.DrawTo dest
		
		nextScreen.image.DrawTo dest, nextScreen.rect.X, nextScreen.rect.Y
		
		prevScreen.image.DrawTo dest, prevScreen.rect.X, prevScreen.rect.Y
		
	End Sub
	
End Namespace