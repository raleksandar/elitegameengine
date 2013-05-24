'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_UI_LABEL_BI__
#Define __EGE_UI_LABEL_BI__

	Type Label
		
		Public:
			
			Declare Property X As Integer
			Declare Property X(newValue As Integer)
			
			Declare Property Y As Integer
			Declare Property Y(newValue As Integer)
			
			Declare Property W As Integer
			Declare Property W(newValue As Integer)
			
			Declare Property H As Integer
			Declare Property H(newValue As Integer)
			
			Declare Sub Size(W As Integer, H As Integer)
			
			Declare Property Font As Font Pointer
			Declare Property Font(newValue As Graphics.Font)
			
			Declare Property Align As TextAlignment
			Declare Property Align(newValue As TextAlignment)
			
			Declare Property Text As String
			Declare Property Text(newValue As String)
			
			Declare Sub DrawTo(dest As Bitmap, srcX As Integer = 0, srcY As Integer = 0, W As Integer = 0, H As Integer = 0, method As RasterOp = fbAlpha, blender As CustomBlenderProc = 0, param As Any Pointer = 0)
			Declare Sub DrawTo(dest As Any Pointer, srcX As Integer = 0, srcY As Integer = 0, W As Integer = 0, H As Integer = 0, method As RasterOp = fbAlpha, blender As CustomBlenderProc = 0, param As Any Pointer = 0)
			
			Declare Destructor
			
		Private:
		
			Declare Sub RecreateBuffer
			Declare Sub RepaintBuffer
		
			mAlign	As TextAlignment = AlignLeft
			mRect	As Rect
			mBuffer	As Bitmap
			mFont	As Graphics.Font
			mText	As String
		
	End Type

#EndIf