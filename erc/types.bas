'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteResource Compiler source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __ERC_TYPES__
#Define __ERC_TYPES__
	
	#Include "dynarray.bi"
	
		
	Type ResType
		Name		As String
		Extension	As String
		GetSection	As Function(section As String) As Integer
		Parse		As Function(sToken() As String, iLineNumber As Integer) As Integer
		Compile		As Function(inputFile As String, outputFile As String) As Integer	
	End Type
	
	DefineDynamicArrayType(  ResType   )
	
#EndIf