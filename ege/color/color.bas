'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_COLOR_BAS__
#Define __EGE_COLOR_BAS__

	' helper function for HSL -> RGB conversion 
	Function Hue2RGB(v1 As Single, v2 As Single, h As Single) As Single
		
		If h < 0 Then
			h += 1
		ElseIf h > 1 Then
			h -= 1
		EndIf
		
		If (6 * h) < 1 Then Return v1 + ( v2 - v1 ) * 6 * h
		If (2 * h) < 1 Then Return v2
		If (3 * h) < 2 Then Return v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - h ) * 6   

		Return v1
			 
	End Function
	
	
	' RGBTriple implementation
	
	Constructor RGBTriple(R As Integer = 0, G As Integer = 0, B As Integer = 0, A As Integer = 255)
		This.nR = R
		This.nG = G
		This.nB = B
		This.nA = A
	End Constructor
	
	Destructor RGBTriple
		This.DestroyHSL
	End Destructor
	
	Sub RGBTriple.DestroyHSL
		NullDelete( This.pHSL )
	End Sub
	
	Property RGBTriple.Red As Integer
		Return This.nR
	End Property
	
	Property RGBTriple.Red(R As Integer)
		This.DestroyHSL
		This.nR = R
	End Property
	
	Property RGBTriple.Green As Integer
		Return This.nG
	End Property
	
	Property RGBTriple.Green(G As Integer)
		This.DestroyHSL
		This.nG = G
	End Property
	
	Property RGBTriple.Blue As Integer
		Return This.nB
	End Property
	
	Property RGBTriple.Blue(B As Integer)
		This.DestroyHSL
		This.nB = B
	End Property
	
	Property RGBTriple.Alpha As Integer
		Return This.nA
	End Property
	
	Property RGBTriple.Alpha(A As Integer)
		This.DestroyHSL
		This.nA = A
	End Property
	
	Property RGBTriple.Value As UInteger
		Return RGBA(This.nR, This.nG, This.nB, This.nA)
	End Property
	
	Property RGBTriple.Value (v As UInteger)
		This.DestroyHSL
		This.nA = *(Cast(UByte Pointer, VarPtr(v)) + 3)
		This.nR = *(Cast(UByte Pointer, VarPtr(v)) + 2)
		This.nG = *(Cast(UByte Pointer, VarPtr(v)) + 1)
		This.nB = *(Cast(UByte Pointer, VarPtr(v)) + 0)	
	End Property
	
	Function RGBTriple.ToHSL As HSLTriplePtr
		
		If Not IsValidPtr( This.pHSL ) Then 
			This.pHSL = New HSLTriple
			This.pHSL->FromRGB VarPtr(This)
		EndIf
		
		Return This.pHSL
		
	End Function
	
	Sub RGBTriple.FromHSL(c As HSLTriplePtr)
		This.FromHSL c->Hue, c->Satituration, c->Lightness
	End Sub
	
	Sub RGBTriple.FromHSL(h As Integer, s As Integer, l As Integer)
		
		If Not IsValidPtr( This.pHSL ) Then This.pHSL = New HSLTriple
		
		This.pHSL->Hue = h
		This.pHSL->Satituration = s
		This.pHSL->Lightness = l
		
		If s = 0 Then
			
			This.nR = (l / 100) * 255
			This.nG = This.nR
			This.nB = This.nR
		
		Else
			
			Dim As Single v1, v2, vS = s / 100, vH = h / 360, vL = l / 100
			
			v2 = IIf( vL < 0.5, vL * ( 1 + vS ), ( vL + vS ) - ( vS * vL ) )
			v1 = 2 * vL - v2
			
			This.nR = 255 * Hue2RGB(v1, v2, vH + (1 / 3))
			This.nG = 255 * Hue2RGB(v1, v2, vH)
			This.nB = 255 * Hue2RGB(v1, v2, vH - (1 / 3))

		EndIf
		
	End Sub
	
	
	' HSLTriple implementation
	
	Constructor HSLTriple(H As Integer = 0, S As Integer = 0, L As Integer = 0)
		This.nH = H
		This.nS = S
		This.nL = L
	End Constructor
	
	Destructor HSLTriple
		This.DestroyRGB
	End Destructor
	
	Sub HSLTriple.DestroyRGB
		NullDelete( This.pRGB )
	End Sub
	
	Property HSLTriple.Hue As Integer
		Return This.nH
	End Property
	
	Property HSLTriple.Hue(H As Integer)
		This.DestroyRGB
		This.nH = H
	End Property
	
	Property HSLTriple.Satituration As Integer
		Return This.nS
	End Property
	
	Property HSLTriple.Satituration(S As Integer)
		This.DestroyRGB
		This.nS = S
	End Property
	
	Property HSLTriple.Lightness As Integer
		Return This.nL
	End Property
	
	Property HSLTriple.Lightness(L As Integer)
		This.DestroyRGB
		This.nL = L
	End Property
	
	Property HSLTriple.Value As UInteger
		
		If Not IsValidPtr( This.pRGB ) Then
			This.pRGB = New RGBTriple
			This.pRGB->FromHSL This.nH, This.nS, This.nL
		EndIf
	
		Return This.pRGB->Value
		
	End Property
	
	Property HSLTriple.Value(v As UInteger)
		
		This.DestroyRGB
		
		This.pRGB = New RGBTriple
		This.pRGB->Value = v
		
		This.FromRGB This.pRGB->Red, This.pRGB->Green, This.pRGB->Blue
			
	End Property
	
	Function HSLTriple.ToRGB As RGBTriplePtr
		
		If Not IsValidPtr( This.pRGB ) Then 
			
			This.pRGB = New RGBTriple
			This.pRGB->FromHSL This.nH, This.nS, This.nL
		
		EndIf
		
		Return This.pRGB
		
	End Function
	
	Sub HSLTriple.FromRGB(c As RGBTriplePtr)
		This.FromRGB c->Red, c->Green, c->Blue
	End Sub
	
	Sub HSLTriple.FromRGB(r As Integer, g As Integer, b As Integer)
		
		If Not IsValidPtr( This.pRGB ) Then This.pRGB = New RGBTriple
		
		This.pRGB->Red = r
		This.pRGB->Green = g
		This.pRGB->Blue = b
		
		Dim As Single vR = r / 255, vG = g / 255, vB = b / 255
		Dim As Single vMin = Math.Min( Math.Min( vR, vG ), vB)
		Dim As Single vMax = Math.Max( Math.Max( vR, vG ), vB)
		Dim As Single delMax = vMax - vMin
		
		This.nS = 0
		This.nH = 0
		This.nL = ( ( vMax + vMin ) / 2) * 100
		
		If delMax <> 0 Then
			
			If This.nL < 50 Then
				This.nS = (delMax / ( vMax + vMin )) * 100
			Else
				This.nS = (delMax / ( 2 - vMax - vMin )) * 100					
			EndIf	
			
			Dim As Single dR = ( ( ( vMax - vR ) / 6 ) + ( delMax / 2 ) ) / delMax
			Dim As Single dG = ( ( ( vMax - vG ) / 6 ) + ( delMax / 2 ) ) / delMax 
			Dim As Single dB = ( ( ( vMax - vB ) / 6 ) + ( delMax / 2 ) ) / delMax
			Dim As Single vH
			
			If vR = vMax Then
				vH = dB - dG
			ElseIf vG = vMax Then
				vH = ( 1 / 3 ) + dR - dB
			Else
				vH = ( 2 / 3 ) + dG - dR
			EndIf
			
			If vH < 0 Then
				vH += 1
			ElseIf vH > 1 Then
				vH -= 1
			EndIf
				
			This.nH = vH * 360
			
		EndIf
		
	End Sub

#EndIf