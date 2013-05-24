
' declarations for first screen

Namespace Screen2
	
	' the game screen
	Dim Shared As Engine.GameScreenHandle	GameScreen
	
	' event handlers
	Declare Sub Game_onInitialize
	Declare Sub Screen_onShow
	Declare Sub Screen_onHide(newScreen As Engine.GameScreenHandle, ByRef Cancel As Elite.Boolean = Elite.False)
	Declare Sub Screen_onFrame(fElapsed As Single, eInputEvent As Engine.InputEvent, eventData As FB.EVENT)
	Declare Sub Screen_onPaint(dest As Engine.Bitmap)
	
	' bitmaps and other declarations
	Dim Shared As Graphics.Bitmap background
	Dim Shared As CameleonButton nextScreen, prevScreen
	Dim Shared As UI.Label title
	
	' finally attach our entry-point subs
	onGameInitialize.Attach ProcPtr(Game_onInitialize)
	
End Namespace