'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_UI_BI__
#Define __EGE_UI_BI__

	Namespace UI

		Using Math, Graphics
		
		Enum TextAlignment
			AlignLeft			= &h0
			AlignRight			= &h2
			AlignCenter			= &h4
			AlignTop			= &h0
			AlignBottom 		= &h20
			AlignMiddle			= &h40
			AlignTopLeft		= AlignLeft   Or  AlignTop
			AlignTopRight		= AlignRight  Or  AlignTop
			AlignTopCenter		= AlignCenter Or  AlignTop
			AlignBottomLeft		= AlignLeft   Or  AlignBottom
			AlignBottomRight	= AlignRight  Or  AlignBottom
			AlignBottomCenter	= AlignCenter Or  AlignBottom
			AlignMiddleLeft		= AlignLeft   Or  AlignMiddle
			AlignMiddleRight	= AlignRight  Or  AlignMiddle
			AlignMiddleCenter	= AlignCenter Or  AlignMiddle
		End Enum
		
		
		#Include "label.bi"		' UI.Label

	End Namespace

#EndIf