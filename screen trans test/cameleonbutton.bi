
' simple button implementation to show how EGE's image filters can be used

Type CameleonButton
	
	rect	As Math.Rect			' placement and size
	image	As Graphics.Bitmap		' bitmap
	hovered	As Elite.Boolean		' hovered state
	pressed	As Elite.Boolean		' pressed state
	
	Declare Sub Create(color As UInteger, bFlip As Elite.Boolean = Elite.False)
	Declare Sub Destroy
	
End Type 


Sub CameleonButton.Create(c As UInteger, bFlip As Elite.Boolean = Elite.False)
	
	Dim As Integer Brightness = 30
	Dim As Color.RGBTriple clr
	Dim As Graphics.Bitmap arrow 
	
	image.LoadFromFile "images/button.png"
	arrow.LoadFromFile "images/arrow.png"
	
	clr.Value = c
	clr.Red = clr.Red - 128
	clr.Green = clr.Green - 128
	clr.Blue = clr.Blue - 128
	
	image.ApplyFilter Engine.fbGrayscale ' grayscale image
	image.ApplyFilter Engine.fbBrightness, VarPtr(Brightness) ' brighten it a bit ( +30% )
	image.ApplyFilter Engine.fbColorOffset, VarPtr(clr) ' colorify it
	
	If bFlip Then 
		
		Dim As Graphics.FlipDirection param = Graphics.fbHorisontal

		arrow.ApplyFilter Engine.fbFlip, VarPtr(param)
		
	EndIf
	
	arrow.DrawTo image, , , , , , , Engine.fbNormal
	
	rect.W = image.Width
	rect.H = image.Height
	
	image.PreserveAlphaChannel
	
	arrow.Destroy
	
	hovered = Elite.False
	pressed = Elite.False

End Sub

Sub CameleonButton.Destroy
	
	image.Destroy
	
End Sub