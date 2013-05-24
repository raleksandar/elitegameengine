'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_FONT_BI__
#Define __EGE_FONT_BI__

	Type _Char Field = 1
		Code		As Integer
		X			As Integer
		Y			As Integer
		W			As Integer
		H			As Integer
		OffsetX		As Integer
		OffsetY		As Integer
	End Type

	Type _KerningPair Field = 1
		FirstChar	As Integer
		SecondChar	As Integer
		KernBy		As Integer
	End Type

	Type Font

		Public:

			Declare Function LoadFromFile(Filename As String) As Elite.Boolean
			Declare Function LoadFromMemory(mem As Any Pointer, size As Integer) As Elite.Boolean

			Declare Sub DrawTo(text As String, dest As Any Pointer, dstX As Integer = 0, dstY As Integer = 0, srcX As Integer = 0, srcY As Integer = 0, W As Integer = 0, H As Integer = 0, method As RasterOp = fbAlpha, blender As CustomBlenderProc = 0, param As Any Pointer = 0)
			Declare Sub DrawTo(text As String, dest As Bitmap, dstX As Integer = 0, dstY As Integer = 0, srcX As Integer = 0, srcY As Integer = 0, W As Integer = 0, H As Integer = 0, method As RasterOp = fbAlpha, blender As CustomBlenderProc = 0, param As Any Pointer = 0)

			Declare Function TextWidth(text As String) As Integer
			Declare Function TextHeight(text As String) As Integer
			
			Declare Sub Destroy
			
			Declare Constructor(Filename As String = "")
			Declare Constructor(mem As Any Pointer, size As Integer)
			Declare Destructor

			WChar			As Integer
			LineHeight		As UInteger
			LineSpacing		As UInteger
			LetterSpacing	As UInteger
			PaddingTop		As Integer
			PaddingLeft		As Integer
			PaddingRight	As Integer
			PaddingBottom	As Integer
			SpaceWidth		As Integer
			TabWidth		As Integer
			TabSize			As Integer

			image			As Bitmap

		Private:
		
			Declare Function GetKerning(first As Integer, second As Integer) As Integer
			Declare Function GetChar(code As Integer) As Integer

			char			As _Char Pointer = NullPtr
			charCount		As Integer
			kerning			As _KerningPair Pointer = NullPtr
			kerningCount	As Integer

	End Type


	IncludeSource( "font.bas" )

#EndIf