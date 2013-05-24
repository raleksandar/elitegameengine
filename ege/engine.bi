'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
#Ifndef __EGE_ENGINE_BI__
#Define __EGE_ENGINE_BI__
	
	Namespace Engine
		
		Using Math, Graphics

		' Engine.Collides methods
		#Include "collision/collision.bi"
		
		
		'{ declare enumerations
		
		' game screen transition effects
		Enum TransitionEffect
			None
			Fade
			SlideIn
			SlideOut
			Push
			ZoomIn
			ZoomOut
			HorisontalStripes
			VerticalStripes
		End Enum
		
		' direction of transition effect (used with SlideIn and SlideOut effects)
		Enum TransitionDirection
			FromLeft
			FromRight
			FromTop
			FromBottom
			FromTopLeft
			FromTopRight
			FromBottomLeft
			FromBottomRight
		End Enum

		' input events available in onFrame handler
		Enum InputEvent
			None						= -1
			KeyPress					= FB.EVENT_KEY_PRESS
			KeyRelease					= FB.EVENT_KEY_RELEASE
			KeyRepeat					= FB.EVENT_KEY_REPEAT
			MouseMove					= FB.EVENT_MOUSE_MOVE
			MouseButtonPress			= FB.EVENT_MOUSE_BUTTON_PRESS
			MouseButtonRelease			= FB.EVENT_MOUSE_BUTTON_RELEASE
			MouseButtonDoubleClick		= FB.EVENT_MOUSE_DOUBLE_CLICK
			MouseWheel					= FB.EVENT_MOUSE_WHEEL
			MouseHWheel					= FB.EVENT_MOUSE_HWHEEL
		End Enum
		
		' scancode constants
		Enum ScanCodes
			KeyEscape					= FB.SC_ESCAPE
        	Key1 						= FB.SC_1
        	Key2 						= FB.SC_2
        	Key3 						= FB.SC_3
        	Key4 						= FB.SC_4
        	Key5 						= FB.SC_5
        	Key6 						= FB.SC_6
        	Key7 						= FB.SC_7
        	Key8						= FB.SC_8
        	Key9 						= FB.SC_9
        	Key0 						= FB.SC_0
        	KeyMinus 					= FB.SC_MINUS
        	KeyEquals 					= FB.SC_EQUALS
        	KeyBackspace 				= FB.SC_BACKSPACE
        	KeyTab 						= FB.SC_TAB
        	KeyQ 						= FB.SC_Q
        	KeyW 						= FB.SC_W
        	KeyE 						= FB.SC_E
        	KeyR 						= FB.SC_R
        	KeyT 						= FB.SC_T
        	KeyY 						= FB.SC_Y
        	KeyU 						= FB.SC_U
        	KeyI 						= FB.SC_I
        	KeyO 						= FB.SC_O
        	KeyP 						= FB.SC_P
        	KeyLeftBracket 				= FB.SC_LEFTBRACKET
        	KeyRightBracket 			= FB.SC_RIGHTBRACKET
        	KeyEnter 					= FB.SC_ENTER
        	KeyControl 					= FB.SC_CONTROL
        	KeyA 						= FB.SC_A
        	KeyS 						= FB.SC_S
        	KeyD 						= FB.SC_D
        	KeyF 						= FB.SC_F
        	KeyG	 					= FB.SC_G
        	KeyH 						= FB.SC_H
        	KeyJ 						= FB.SC_J
        	KeyK 						= FB.SC_K
        	KeyL 						= FB.SC_L
        	KeySmicolon 				= FB.SC_SEMICOLON
        	KeyQuote 					= FB.SC_QUOTE
        	KeyTilde 					= FB.SC_TILDE
        	KeyLeftShift 				= FB.SC_LSHIFT
        	KeyBackslash 				= FB.SC_BACKSLASH
        	KeyZ 						= FB.SC_Z
        	KeyX 						= FB.SC_X
        	KeyC 						= FB.SC_C
        	KeyV 						= FB.SC_V
        	KeyB 						= FB.SC_B
        	KeyN 						= FB.SC_N
        	KeyM 						= FB.SC_M
        	KeyComma 					= FB.SC_COMMA
        	KeyPeriod 					= FB.SC_PERIOD
        	KeySlash 					= FB.SC_SLASH
        	KeyRightShift 				= FB.SC_RSHIFT
        	KeyMultiply 				= FB.SC_MULTIPLY
        	KeyAlt 						= FB.SC_ALT
        	KeySpace 					= FB.SC_SPACE
        	KeyCapsLock 				= FB.SC_CAPSLOCK
        	KeyF1 						= FB.SC_F1
        	KeyF2 						= FB.SC_F2
        	KeyF3 						= FB.SC_F3
        	KeyF4 						= FB.SC_F4
        	KeyF5 						= FB.SC_F5
        	KeyF6 						= FB.SC_F6
        	KeyF7						= FB.SC_F7
        	KeyF8 						= FB.SC_F8
        	KeyF9 						= FB.SC_F9
        	KeyF10 						= FB.SC_F10
        	KeyNumLock 					= FB.SC_NUMLOCK
        	KeyScrollLock 				= FB.SC_SCROLLLOCK
        	KeyHome 					= FB.SC_HOME
        	KeyUp 						= FB.SC_UP         
        	KeyPageUp 					= FB.SC_PAGEUP
        	KeyLeft 					= FB.SC_LEFT
        	KeyRight 					= FB.SC_RIGHT
        	KeyPlus 					= FB.SC_PLUS
        	KeyEnd 						= FB.SC_END
        	KeyDown 					= FB.SC_DOWN
        	KeyPageDown 				= FB.SC_PAGEDOWN
        	KeyInsert 					= FB.SC_INSERT
        	KeyDelete 					= FB.SC_DELETE
        	KeyF11 						= FB.SC_F11
        	KeyF12 						= FB.SC_F12
        	KeyLeftWin 					= FB.SC_LWIN
        	KeyRightWin 				= FB.SC_RWIN
        	KeyMenu 					= FB.SC_MENU			
		End Enum
		
		Enum MouseButton
			LeftButton					= FB.BUTTON_LEFT
			RightButton					= FB.BUTTON_RIGHT
			MiddleButton				= FB.BUTTON_MIDDLE
			X1Button					= FB.BUTTON_X1
			X2Button					= FB.BUTTON_X2
		End Enum
		
		
		' for use with MouseOverObject
		Enum TestType
			AlphaValue
			TransColor
		End Enum
		
		'}
		
		'{ declare types
		
		' holds information about screen resolution
		Type Resolution
			
			Width	As Integer
			Height	As Integer
			Depth	As Integer
			
			Declare Operator Cast As String
			
		End Type
		
		' list of screen resolutions
		Type ResolutionList
			
			Count	As Integer
			List	As Resolution Pointer = NullPtr
			
			Declare Sub Add(w As Integer, h As Integer, d As Integer)
			
		End Type
		
		
		' game screen handle
		Type GameScreenHandle As Integer
		
		Const IllegalScreenHandle	As GameScreenHandle = -1
		
		
		' game timer
		
		SimpleEvent( onInterval )
				
		Type GameTimer
			
			Public:
					
				Interval	As Double
				onInterval	As onIntervalEvent
				
				Declare Sub Start
				Declare Sub Pause
				Declare Sub Stop
				
				Declare Sub onFrame(fElapsed As Single)
			
			Private:
				
				state		As Integer	' 0 - stoped, 1 - running, 2 - paused
				elapsed		As Double	
			
		End Type
		

		SimpleEvent( onLoad )		
		SimpleEvent( onShow )
		SimpleEvent( onTransitionEnd )
		CreateEvent( onHide, (newScreen, Cancel), (newScreen As GameScreenHandle, ByRef Cancel As Elite.Boolean = Elite.False) )
		CreateEvent( onPaint, (dest), (dest As Bitmap) )
		CreateEvent( onFrame, (fElapsed, eInputEvent, eventData), (fElapsed As Single, eInputEvent As InputEvent, eventData As FB.EVENT) )
		
		' game screen events
		Type GameScreenEvents
			onLoad			As onLoadEvent
			onShow			As onShowEvent
			onHide			As onHideEvent
			onPaint			As onPaintEvent
			onFrame			As onFrameEvent
			onTransitionEnd	As onTransitionEndEvent
			loaded			As Elite.Boolean = Elite.False
		End Type
		
		'}
		
		
		'{ declare variables
			
		Const SystemCursor As Any Pointer = 0
		
		Dim Shared As Resolution			ScreenResolution						' screen resolution
		Dim Shared As GameScreenEvents		GameScreen()							' array of game screens
		Dim Shared As Integer				ActiveGameScreen = IllegalScreenHandle	' currently displaying screen
		Dim Shared As Integer				ScreenCount = 0							' number of game screens
		Dim Shared As Elite.Boolean			Started = Elite.False					' are we Started already?
		Dim Shared As Elite.Boolean			MouseCursorVisible = Elite.False		' is the mouse cursor visible?
		

		'}
		

		'{ declare events
		
		' engine is ready and game code can start executing	
		SharedSimpleEvent( onInitialize )
		
		' Engine.Shutdown is called (set Cancel to Elite.True in handler, to cancel shutdown)		
		SharedEvent( onShutdown, (Cancel), (ByRef Cancel As Elite.Boolean) )
		
		' exiting from application
		SharedSimpleEvent( onDestroy )
		
		' game is started (just before game loop starts)
		SharedSimpleEvent( onStart )
		
		' mouse enters window's area
		SharedSimpleEvent( onMouseEnter )
		
		' mouse leaves window's area
		SharedSimpleEvent( onMouseLeave )
		
		' window gots focus
		SharedSimpleEvent( onFocus )
		
		' window loses focus
		SharedSimpleEvent( onBlur )
		
		' this one is raised just before onInitialize and should not be use by game code (some parts of engine use this event)
		SharedSimpleEvent( onBeforeInitialize )
		
		' called when transition screen is created		
		SharedEvent( onTransitionsLoaded, (TransitionsScreen), (TransitionsScreen As GameScreenHandle) )

		'}


		'{ declare methods
			
		Declare Function Initialize OverLoad(res As Resolution, fs As Elite.Boolean = Elite.False, flags As Integer = 0) As Elite.Boolean
		Declare Function Initialize (w As Integer, h As Integer, fs As Elite.Boolean = Elite.False, flags As Integer = 0) As Elite.Boolean
		
		Declare Function NewGameScreen As GameScreenHandle 
		Declare Sub Show(scr As GameScreenHandle, transMethod As TransitionEffect = TransitionEffect.None, transDir As TransitionDirection = TransitionDirection.FromLeft, easing As Effect.Easing = Effect.Linear, duration As Single = 0.7)
		
		Declare Sub ShowCursor
		Declare Sub HideCursor
		Declare Sub SetCursor(cursor As Bitmap Pointer, X As Integer = 0, Y As Integer = 0)
		
		Declare Function MouseOverObject(obj As Bitmap, rect As Math.Rect, mode As TestType = AlphaValue, value As UInteger = 100) As Elite.Boolean 
		
		Declare Sub Repaint
		
		Declare Sub Start
		
		Declare Function Shutdown(Force As Elite.Boolean = Elite.False, RaiseEvent As Elite.Boolean = Elite.True) As Elite.Boolean
		
		Declare Function SupportedResolutions(depth As Integer = 32) As ResolutionList
		
		'}
		
		
		#Include "transitions/transitions.bi"	' screen transition effects
		
		IncludeSource( "engine.bas" )
		
	End Namespace

#EndIf