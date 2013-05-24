/'

	EliteGameEngine - 2D Game Engine in FreeBASIC


	libraries used:

		GFXLib 2
			- Copyright (c) 2004 - 2007 The FreeBASIC development Team
			  http://www.freebasic.net

		FbPng 1.9.0
			- Copyright (c) 2007 Simon Nash
			  http://www.freebasic.net/arch/file.php?id=23


	version history:

		0.0.1.060408.d	- 0.0.1 draft
		--------------
			+ implemented event handling routines
			+ implemented Engine namespace
			+ implemented Bitmap type


		0.0.2.120408.d	- 0.0.2 draft
		--------------
			+ implemented filters
			+ implemented blending modes
			+ implemented Color namespace
			+ implemented Math namespace (not yet completed)


		0.0.3.280408.d	- 0.0.3 draft
		--------------
			+ implemented Animation type and easing effects
			+ implemented screen transition effects
			+ implemented Choice type (in Math namespace)
			+ implemented bilinear scaling of images
			+ added new image filters - PixelOffset and Flip
			+ reorganized project's file/folder structure


		0.0.4.290408.d	- 0.0.4 draft (a "bugfix" version)
		--------------
			+ fixed serious bugs that were causing application to crash sometimes
			+ added new transition effect - Push
			+ added new image filters - Convolution, FindEdges and Blur
			+ added Alpha property to RGBTriple type


		0.0.5.070508.d	- 0.0.5 draft
		--------------
			+ implemented Graphics.Font type
			+ implemented UI.Label type
			+ implemented System namespace (currently only on windows)
			+ added onLoad and onTransitionEnd screen events
			+ changed Animation type to allow different easing effects for each animated value
			+ added Running and Time properties and Stop method to Animation type
			+ removed unneeded first parameter (x) in EasingFunction
			+ changed screen transitions code as reflection of changes to Animation type
			+ added onClose event handler to screen transition effects
			+ fixed bug in displacement filters when used on non-square bitmaps (PixelOffset, Flip)
			+ added new image filters - PixelOffsetAntiAlias, Water, Swirl, RandomJitter, Mozaic
			+ added new easing effects - CircIn, CircOut, CircInOut, SineIn, SineOut and SineInOut
			+ added color depth info to Engine.Resolution type
			+ changed Engine.ResolutionList type and Engine.SupportedResolutions function
			+ fixed bug that were causing MouseCursorPosition not to be updated when using system cursor
			+ changed CreateEvent macro, added CreateCustomEvent, CustomSimpleEvent, CustomSharedEvent and CustomSharedSimpleEvent macros
			+ added Engine.onTransitionsLoaded event
			+ added Engine.GameTimer type
			+ fixed bugs in Color.HSLTriple and Effect.Animation (pointers-related)



	developers (EliteGames Team):

		Aleksandar Ruzicic	< ruzicic.aleksandar@gmail.com >


	licence:

		Copyright (c) 2008 EliteGames Team

		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:

		The above copyright notice and this permission notice shall be included in
		all copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
		THE SOFTWARE.



		Unless otherwise noted this licence (including the copyright notice) applies
		to all code in each file that has following notice (on top of that file):

			"This file is part of EliteGameEngine source distribution"

'/


#Ifndef __EGE_MAIN__
#Define __EGE_MAIN__

	#Include Once "fbgfx.bi"					' GFXLib 2
	#Include Once "fbpng.bi"					' FbPng

Namespace Elite

	#Macro IncludeSource(SRC)
		#Ifndef EGE_STATIC_LIB
			#Include Once SRC
		#EndIf
	#EndMacro


	Enum Boolean
		False 	= 0
		True  	= Not False
	End Enum


	' for easier dealing with pointers
	#Define NullPtr				0
	#Define IsValidPtr(p)		((p) <> NullPtr)
	#Define NullDelete(p) 		If IsValidPtr(p) Then 	Delete p	:  p = 0
	#Define NullDeleteArray(p)	If IsValidPtr(p) Then 	Delete[] p 	:  p = 0
	' --


	#Include Once "system/system.bi"		' System namespace
	#Include Once "event/event.bi"			' CreateEvent macro (not in Elite namespace - cuz it's macro)
	#Include Once "math/math.bi"			' Math namespace
	#Include Once "color/color.bi"			' Color namespace
	#Include Once "graphics/graphics.bi"	' Graphics namespace
	#Include Once "effects/effects.bi"		' Effect namespace
	#Include Once "ui/ui.bi"				' UI namespace
	#Include Once "engine.bi"				' Engine namespace


	IncludeSource( "effects/effects.bas" )
	IncludeSource( "ui/ui.bas" )


	#Ifdef EGE_STATIC_LIB
		#If __FB_DEBUG__
			#Inclib "eged"
		#Else
			#Inclib "ege"
		#EndIf
	#EndIf


	#Undef IncludeSource

End Namespace

#EndIf