
#Include "../ege.bi"		' import EGE source 

Using Elite					' we use Elite Namespace


' first we declare our starting point (the Engine.onInitialize event handler)
Declare Sub Game_onInitialize


' let's make some custom events (CustomSharedSimpleEvent macro creates event without arguments)

' this event will be raised when screens should be created and their event handlers attached
CustomSharedSimpleEvent( onGameInitialize )

' this event will be raised when first screen should be shown
CustomSharedSimpleEvent( onGameReady )



' declare cursor bitmap variable (this example uses same cursor for each screen, but you can use different cursor for each screen if you like)
Dim Shared As Graphics.Bitmap bmpCursor

' custom bitmap font
Dim Shared As Graphics.Font bmpFont


' displays game screen using random transition and easing effect 
Declare Sub ShowScreen(scr As Engine.GameScreenHandle)


' CameleonButton type
#Include "cameleonbutton.bi"

' now we include declarations for each screen
#Include "screens/screen1.bi"
#Include "screens/screen2.bi"
#Include "screens/screen3.bi"
#Include "screens/screen4.bi"


' and then we include implmentation code for each screen
#Include "screens/screen1.bas"
#Include "screens/screen2.bas"
#Include "screens/screen3.bas"
#Include "screens/screen4.bas"



' now we implement onInitialize event handler
Sub Game_onInitialize
	
	onGameInitialize.Raise	' create all screens and attach events
	
	bmpCursor.LoadFromFile("images/cursor.png")			' load cursor bitmap	
	
	Engine.SetCursor VarPtr(bmpCursor), 5, 5			' set custom cursor bitmap
	Engine.ShowCursor									' show mouse cursor
	
	bmpFont.LoadFromFile "fonts/sample.ebf"				' load bitmap font
	
	onGameReady.Raise		' show first screen
		
End Sub

' in module constructor we attach onInitialize event handler
Sub Module Constructor
	
	Engine.onInitialize.Attach ProcPtr(Game_onInitialize)
	
End Sub


	' set title for our game window
	WindowTitle "EliteGameEngine screen transitions demo"

	' and finaly we can start the game!
	Engine.Initialize 640, 480, False, FB.GFX_NO_SWITCH	' 640x480, windowed, disable fullscreen switch


	End 0 ' be sure to exit :)




Sub ShowScreen(scr As Engine.GameScreenHandle)
	
	Dim transEffect  As Engine.TransitionEffect = Math.Random(Engine.Fade, Engine.VerticalStripes)
	Dim transDir 	 As Engine.TransitionDirection = Math.Random(Engine.FromLeft, Engine.FromBottomRight)
	Dim easingEffect As Effect.Easing = Math.Random(Effect.Linear, Effect.CubicInOut)
	
	Engine.Show scr, transEffect, transDir, easingEffect, 2
	
End Sub