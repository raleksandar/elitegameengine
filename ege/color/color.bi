'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_COLOR_BI__
#Define __EGE_COLOR_BI__
	
	#Undef Color	' FreeBASIC's Color statement cannot be used together with EGE, sorry...
	
	Namespace Color
		
		Type RGBTriplePtr As RGBTriple Pointer
		Type HSLTriplePtr As HSLTriple Pointer
		
		Type RGBTriple ' it's acctualy RGBAQuad but...
			
			Public:
			
				Declare Property Red As Integer
				Declare Property Red(R As Integer)
				
				Declare Property Green As Integer
				Declare Property Green(G As Integer)
				
				Declare Property Blue As Integer
				Declare Property Blue(B As Integer)
				
				Declare Property Alpha As Integer
				Declare Property Alpha(A As Integer)
				
				Declare Property Value As UInteger
				Declare Property Value(v As UInteger)
				
				Declare Function ToHSL As HSLTriplePtr
				Declare Sub FromHSL(c As HSLTriplePtr)
				Declare Sub FromHSL(h As Integer, s As Integer, l As Integer)
				
				Declare Constructor(Red As Integer = 0, Green As Integer = 0, Blue As Integer = 0, Alpha As Integer = 255)
				
				Declare Destructor
				Declare Sub DestroyHSL
			
			Private:
				
				nR		As Integer
				nG		As Integer
				nB		As Integer
				nA		As Integer
				
				pHSL	As HSLTriplePtr = NullPtr
			
		End Type
		
		Type HSLTriple
			
			Public:
			
				Declare Property Hue As Integer
				Declare Property Hue(H As Integer)
				
				Declare Property Satituration As Integer
				Declare Property Satituration(S As Integer)
				
				Declare Property Lightness As Integer
				Declare Property Lightness(L As Integer)
				
				Declare Property Value As UInteger
				Declare Property Value(v As UInteger)
				
				Declare Function ToRGB As RGBTriplePtr
				Declare Sub FromRGB(c As RGBTriplePtr)
				Declare Sub FromRGB(r As Integer, g As Integer, b As Integer)
				
				Declare Constructor(H As Integer = 0, S As Integer = 0, L As Integer = 0)
				
				Declare Destructor
				Declare Sub DestroyRGB
			
			Private:
				
				nH		As Integer
				nS		As Integer
				nL		As Integer
				
				pRGB	As RGBTriplePtr = NullPtr
			
		End Type
		
		
		
		' color constants
		
		Const AliceBlue 			As Uinteger = RGBA(&Hf0, &Hf8, &Hff, &Hff)
		Const AntiqueWhite 			As Uinteger = RGBA(&Hfa, &Heb, &Hd7, &Hff)
		Const Aqua 					As Uinteger = RGBA(&H00, &Hff, &Hff, &Hff)
		Const Aquamarine 			As Uinteger = RGBA(&H7f, &Hff, &Hd4, &Hff)
		Const Azure 				As Uinteger = RGBA(&Hf0, &Hff, &Hff, &Hff)
		Const Beige 				As Uinteger = RGBA(&Hf5, &Hf5, &Hdc, &Hff)
		Const Bisque 				As Uinteger = RGBA(&Hff, &He4, &Hc4, &Hff)
		Const Black 				As Uinteger = RGBA(&H00, &H00, &H00, &Hff)
		Const BlanchedAlmond 		As Uinteger = RGBA(&Hff, &Heb, &Hcd, &Hff)
		Const Blue 					As Uinteger = RGBA(&H00, &H00, &Hff, &Hff)
		Const BlueViolet 			As Uinteger = RGBA(&H8a, &H2b, &He2, &Hff)
		Const Brown 				As Uinteger = RGBA(&Ha5, &H2a, &H2a, &Hff)
		Const BurlyWood 			As Uinteger = RGBA(&Hde, &Hb8, &H87, &Hff)
		Const CadetBlue 			As Uinteger = RGBA(&H5f, &H9e, &Ha0, &Hff)
		Const Chartreuse 			As Uinteger = RGBA(&H7f, &Hff, &H00, &Hff)
		Const Chocolate 			As Uinteger = RGBA(&Hd2, &H69, &H1e, &Hff)
		Const Coral 				As Uinteger = RGBA(&Hff, &H7f, &H50, &Hff)
		Const CornflowerBlue 		As Uinteger = RGBA(&H64, &H95, &Hed, &Hff)
		Const Cornsilk 				As Uinteger = RGBA(&Hff, &Hf8, &Hdc, &Hff)
		Const Crimson 				As Uinteger = RGBA(&Hdc, &H14, &H3c, &Hff)
		Const Cyan 					As Uinteger = RGBA(&H00, &Hff, &Hff, &Hff)
		Const DarkBlue 				As Uinteger = RGBA(&H00, &H00, &H8b, &Hff)
		Const DarkCyan 				As Uinteger = RGBA(&H00, &H8b, &H8b, &Hff)
		Const DarkGoldenrod 		As Uinteger = RGBA(&Hb8, &H86, &H0b, &Hff)
		Const DarkGray 				As Uinteger = RGBA(&Ha9, &Ha9, &Ha9, &Hff)
		Const DarkGreen 			As Uinteger = RGBA(&H00, &H64, &H00, &Hff)
		Const DarkKhaki 			As Uinteger = RGBA(&Hbd, &Hb7, &H6b, &Hff)
		Const DarkMagenta 			As Uinteger = RGBA(&H8b, &H00, &H8b, &Hff)
		Const DarkOliveGreen 		As Uinteger = RGBA(&H55, &H6b, &H2f, &Hff)
		Const DarkOrange 			As Uinteger = RGBA(&Hff, &H8c, &H00, &Hff)
		Const DarkOrchid 			As Uinteger = RGBA(&H99, &H32, &Hcc, &Hff)
		Const DarkRed 				As Uinteger = RGBA(&H8b, &H00, &H00, &Hff)
		Const DarkSalmon 			As Uinteger = RGBA(&He9, &H96, &H7a, &Hff)
		Const DarkSeaGreen 			As Uinteger = RGBA(&H8f, &Hbc, &H8b, &Hff)
		Const DarkSlateBlue 		As Uinteger = RGBA(&H48, &H3d, &H8b, &Hff)
		Const DarkSlateGray 		As Uinteger = RGBA(&H2f, &H4f, &H4f, &Hff)
		Const DarkTurquoise 		As Uinteger = RGBA(&H00, &Hce, &Hd1, &Hff)
		Const DarkViolet 			As Uinteger = RGBA(&H94, &H00, &Hd3, &Hff)
		Const DeepPink 				As Uinteger = RGBA(&Hff, &H14, &H93, &Hff)
		Const DeepSkyBlue 			As Uinteger = RGBA(&H00, &Hbf, &Hff, &Hff)
		Const DimGray 				As Uinteger = RGBA(&H69, &H69, &H69, &Hff)
		Const DodgerBlue 			As Uinteger = RGBA(&H1e, &H90, &Hff, &Hff)
		Const Firebrick 			As Uinteger = RGBA(&Hb2, &H22, &H22, &Hff)
		Const FloralWhite 			As Uinteger = RGBA(&Hff, &Hfa, &Hf0, &Hff)
		Const ForestGreen 			As Uinteger = RGBA(&H22, &H8b, &H22, &Hff)
		Const Fuchsia 				As Uinteger = RGBA(&Hff, &H00, &Hff, &Hff)
		Const Gainsboro 			As Uinteger = RGBA(&Hdc, &Hdc, &Hdc, &Hff)
		Const GhostWhite 			As Uinteger = RGBA(&Hf8, &Hf8, &Hff, &Hff)
		Const Gold 					As Uinteger = RGBA(&Hff, &Hd7, &H00, &Hff)
		Const Goldenrod 			As Uinteger = RGBA(&Hda, &Ha5, &H20, &Hff)
		Const Gray 					As Uinteger = RGBA(&H80, &H80, &H80, &Hff)
		Const Green 				As Uinteger = RGBA(&H00, &H80, &H00, &Hff)
		Const GreenYellow 			As Uinteger = RGBA(&Had, &Hff, &H2f, &Hff)
		Const Honeydew 				As Uinteger = RGBA(&Hf0, &Hff, &Hf0, &Hff)
		Const HotPink 				As Uinteger = RGBA(&Hff, &H69, &Hb4, &Hff)
		Const IndianRed 			As Uinteger = RGBA(&Hcd, &H5c, &H5c, &Hff)
		Const Indigo 				As Uinteger = RGBA(&H4b, &H00, &H82, &Hff)
		Const Ivory 				As Uinteger = RGBA(&Hff, &Hff, &Hf0, &Hff)
		Const Khaki 				As Uinteger = RGBA(&Hf0, &He6, &H8c, &Hff)
		Const Lavender 				As Uinteger = RGBA(&He6, &He6, &Hfa, &Hff)
		Const LavenderBlush 		As Uinteger = RGBA(&Hff, &Hf0, &Hf5, &Hff)
		Const LawnGreen 			As Uinteger = RGBA(&H7c, &Hfc, &H00, &Hff)
		Const LemonChiffon 			As Uinteger = RGBA(&Hff, &Hfa, &Hcd, &Hff)
		Const LightBlue 			As Uinteger = RGBA(&Had, &Hd8, &He6, &Hff)
		Const LightCoral 			As Uinteger = RGBA(&Hf0, &H80, &H80, &Hff)
		Const LightCyan 			As Uinteger = RGBA(&He0, &Hff, &Hff, &Hff)
		Const LightGoldenrodYellow	As Uinteger = RGBA(&Hfa, &Hfa, &Hd2, &Hff)
		Const LightGray 			As Uinteger = RGBA(&Hd3, &Hd3, &Hd3, &Hff)
		Const LightGreen 			As Uinteger = RGBA(&H90, &Hee, &H90, &Hff)
		Const LightPink 			As Uinteger = RGBA(&Hff, &Hb6, &Hc1, &Hff)
		Const LightSalmon 			As Uinteger = RGBA(&Hff, &Ha0, &H7a, &Hff)
		Const LightSeaGreen 		As Uinteger = RGBA(&H20, &Hb2, &Haa, &Hff)
		Const LightSkyBlue 			As Uinteger = RGBA(&H87, &Hce, &Hfa, &Hff)
		Const LightSlateGray 		As Uinteger = RGBA(&H77, &H88, &H99, &Hff)
		Const LightSteelBlue 		As Uinteger = RGBA(&Hb0, &Hc4, &Hde, &Hff)
		Const LightYellow 			As Uinteger = RGBA(&Hff, &Hff, &He0, &Hff)
		Const Lime 					As Uinteger = RGBA(&H00, &Hff, &H00, &Hff)
		Const LimeGreen 			As Uinteger = RGBA(&H32, &Hcd, &H32, &Hff)
		Const Linen 				As Uinteger = RGBA(&Hfa, &Hf0, &He6, &Hff)
		Const Magenta 				As Uinteger = RGBA(&Hff, &H00, &Hff, &Hff)
		Const Maroon 				As Uinteger = RGBA(&H80, &H00, &H00, &Hff)
		Const MediumAquamarine 		As Uinteger = RGBA(&H66, &Hcd, &Haa, &Hff)
		Const MediumBlue 			As Uinteger = RGBA(&H00, &H00, &Hcd, &Hff)
		Const MediumOrchid 			As Uinteger = RGBA(&Hba, &H55, &Hd3, &Hff)
		Const MediumPurple 			As Uinteger = RGBA(&H93, &H70, &Hdb, &Hff)
		Const MediumSeaGreen 		As Uinteger = RGBA(&H3c, &Hb3, &H71, &Hff)
		Const MediumSlateBlue 		As Uinteger = RGBA(&H7b, &H68, &Hee, &Hff)
		Const MediumSpringGreen 	As Uinteger = RGBA(&H00, &Hfa, &H9a, &Hff)
		Const MediumTurquoise 		As Uinteger = RGBA(&H48, &Hd1, &Hcc, &Hff)
		Const MediumVioletRed 		As Uinteger = RGBA(&Hc7, &H15, &H85, &Hff)
		Const MidnightBlue 			As Uinteger = RGBA(&H19, &H19, &H70, &Hff)
		Const MintCream 			As Uinteger = RGBA(&Hf5, &Hff, &Hfa, &Hff)
		Const MistyRose 			As Uinteger = RGBA(&Hff, &He4, &He1, &Hff)
		Const Moccasin 				As Uinteger = RGBA(&Hff, &He4, &Hb5, &Hff)
		Const NavajoWhite 			As Uinteger = RGBA(&Hff, &Hde, &Had, &Hff)
		Const Navy 					As Uinteger = RGBA(&H00, &H00, &H80, &Hff)
		Const OldLace 				As Uinteger = RGBA(&Hfd, &Hf5, &He6, &Hff)
		Const Olive 				As Uinteger = RGBA(&H80, &H80, &H00, &Hff)
		Const OliveDrab 			As Uinteger = RGBA(&H6b, &H8e, &H23, &Hff)
		Const Orange 				As Uinteger = RGBA(&Hff, &Ha5, &H00, &Hff)
		Const OrangeRed 			As Uinteger = RGBA(&Hff, &H45, &H00, &Hff)
		Const Orchid 				As Uinteger = RGBA(&Hda, &H70, &Hd6, &Hff)
		Const PaleGoldenrod 		As Uinteger = RGBA(&Hee, &He8, &Haa, &Hff)
		Const PaleGreen 			As Uinteger = RGBA(&H98, &Hfb, &H98, &Hff)
		Const PaleTurquoise 		As Uinteger = RGBA(&Haf, &Hee, &Hee, &Hff)
		Const PaleVioletRed 		As Uinteger = RGBA(&Hdb, &H70, &H93, &Hff)
		Const PapayaWhip 			As Uinteger = RGBA(&Hff, &Hef, &Hd5, &Hff)
		Const PeachPuff 			As Uinteger = RGBA(&Hff, &Hda, &Hb9, &Hff)
		Const Peru 					As Uinteger = RGBA(&Hcd, &H85, &H3f, &Hff)
		Const Pink 					As Uinteger = RGBA(&Hff, &Hc0, &Hcb, &Hff)
		Const Plum 					As Uinteger = RGBA(&Hdd, &Ha0, &Hdd, &Hff)
		Const PowderBlue 			As Uinteger = RGBA(&Hb0, &He0, &He6, &Hff)
		Const Purple 				As Uinteger = RGBA(&H80, &H00, &H80, &Hff)
		Const Red 					As Uinteger = RGBA(&Hff, &H00, &H00, &Hff)
		Const RosyBrown 			As Uinteger = RGBA(&Hbc, &H8f, &H8f, &Hff)
		Const RoyalBlue 			As Uinteger = RGBA(&H41, &H69, &He1, &Hff)
		Const SaddleBrown 			As Uinteger = RGBA(&H8b, &H45, &H13, &Hff)
		Const Salmon 				As UInteger = RGBA(&Hfa, &H80, &H72, &Hff)
		Const SandyBrown 			As Uinteger = RGBA(&Hf4, &Ha4, &H60, &Hff)
		Const SeaGreen 				As Uinteger = RGBA(&H2e, &H8b, &H57, &Hff)
		Const SeaShell 				As Uinteger = RGBA(&Hff, &Hf5, &Hee, &Hff)
		Const Sienna 				As Uinteger = RGBA(&Ha0, &H52, &H2d, &Hff)
		Const Silver 				As Uinteger = RGBA(&Hc0, &Hc0, &Hc0, &Hff)
		Const SkyBlue 				As Uinteger = RGBA(&H87, &Hce, &Heb, &Hff)
		Const SlateBlue 			As Uinteger = RGBA(&H6a, &H5a, &Hcd, &Hff)
		Const SlateGray 			As Uinteger = RGBA(&H70, &H80, &H90, &Hff)
		Const Snow 					As Uinteger = RGBA(&Hff, &Hfa, &Hfa, &Hff)
		Const SpringGreen 			As Uinteger = RGBA(&H00, &Hff, &H7f, &Hff)
		Const SteelBlue 			As Uinteger = RGBA(&H46, &H82, &Hb4, &Hff)
		Const Tan 					As Uinteger = RGBA(&Hd2, &Hb4, &H8c, &Hff)
		Const Teal 					As Uinteger = RGBA(&H00, &H80, &H80, &Hff)
		Const Thistle 				As Uinteger = RGBA(&Hd8, &Hbf, &Hd8, &Hff)
		Const Tomato 				As Uinteger = RGBA(&Hff, &H63, &H47, &Hff)
		Const Transparent 			As Uinteger = RGBA(&Hff, &H00, &Hff, &H00)
		Const Turquoise 			As Uinteger = RGBA(&H40, &He0, &Hd0, &Hff)
		Const Violet 				As Uinteger = RGBA(&Hee, &H82, &Hee, &Hff)
		Const Wheat 				As Uinteger = RGBA(&Hf5, &Hde, &Hb3, &Hff)
		Const White 				As Uinteger = RGBA(&Hff, &Hff, &Hff, &Hff)
		Const WhiteSmoke 			As Uinteger = RGBA(&Hf5, &Hf5, &Hf5, &Hff)
		Const Yellow 				As Uinteger = RGBA(&Hff, &Hff, &H00, &Hff)
		Const YellowGreen 			As Uinteger = RGBA(&H9a, &Hcd, &H32, &Hff)
		
		
		IncludeSource( "color.bas" )
				
	End Namespace

#EndIf		