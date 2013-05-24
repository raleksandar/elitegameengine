/'

	EliteResource Compiler - tool for building resource files for use in EliteGameEngine


	version history:

		1.0.110408.b  - first beta version released


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

			"This file is part of EliteResource Compiler source distribution"

'/

#Define COMPILER_VERSION "1.0.b"
#Define COPYRIGHT "Copyright (c) 2008. EliteGames"

#Define CODE_OK 					0
#Define CODE_NO_INPUT_FILE 			1
#Define CODE_FILE_NOT_FOUND			2
#Define CODE_CANT_OPEN				3
#Define CODE_TOO_MUCH_ERRORS		4


#Define MAXIMUM_NUMBER_OF_ERRORS 	10

#Include "types.bas"
#Include "functions.bas"


Declare Sub RegisterResourceType(ByRef resType As ResType)


Function MakeVersion(major As Integer, minor As Integer) As Integer
	Return CInt(CUShort(major) Or (CUInt(CUShort(minor)) Shl 16))
End Function


#Include "bitmapfont.bas"		'' BitmapFont resource


#Include "file.bi"


Dim As Integer argc = 1, printHelp = 0
Dim As String argv, inputFile, outputFile

Dim Shared resourceTypes As ResTypeArray

Do
	argv = Command(argc)

	If Len(argv) = 0 Then Exit Do

	If Left(argv, 2) = "-o" Then
		outputFile = Mid(argv, 3)
	ElseIf argv = "-h" Then
		printHelp = 1
	Else
		inputFile = argv
	EndIf

	argc += 1

Loop

If argc = 1 Or printHelp Then

	Print ""
	Print "ERC - EliteResource Compiler"
	Print COPYRIGHT
	Print "version: "; COMPILER_VERSION
	Print ""
	Print " USAGE:  ERC script[.erd] [options]"
	Print ""
	Print " Options:"
	Print ""
	Print "  -oFNAME   Sets output filename to FNAME"
	Print "  -h        Prints usage info (this text)"
	Print ""
	Print ""

	If printHelp Then
		Print "Press any key to continue..."
		Sleep
	EndIf

Else

	If Len(inputFile) = 0 Then
		Print "Input file not specified"
		End CODE_NO_INPUT_FILE
	EndIf

	If Not FileExists(inputFile) Then
		If Not FileExists(ReplaceExt(inputFile, "erd")) Then
			Print "File not found"
			End CODE_FILE_NOT_FOUND
		EndIf
		inputFile = ReplaceExt(inputFile, "erd")
	EndIf

	Dim As Integer fn = FreeFile, comment = 0
	Dim As String sLine

	Dim As String sToken()
	Dim As Integer iSize = 0, iLineNumber = 0, iErrors = 0

	Dim As Integer describe = -1, curSection = -1



	If Open(inputFile For Input Access Read Lock Write As fn) = 0 Then

		While Not Eof(fn)

			iLineNumber += 1

			Line Input #fn, sLine

			sLine = Trim(sLine, Any Chr(9, 11, 32, 160))

			comment = InStr(sLine, "''")

			If comment > 0 Then
				sLine = Left(sLine, comment - 1)
			EndIf

			sLine = Replace(sLine, Chr(9), " ")
			sLine = Replace(sLine, Chr(11), " ")
			sLine = Replace(sLine, Chr(160), " ")

			While InStr(sLine, "  ") > 0
				sLine = Replace(sLine, "  ", " ")
			Wend

			If Len(sLine) > 0 Then

				iSize = Split(sLine, " ", sToken())

				If LCase(sToken(0)) = "describe" Then
					If describe = -1 Then
						If iSize <> 2 Then
							iErrors += 1
							Print "Error: Argument count missmatch ('Describe' accepts 1 argument, "; Str(iSize) ;" found) at line "; Str(iLineNumber)
						Else
							For i As Integer = 0 To resourceTypes.ItemCount - 1
								If LCase(sToken(1)) = LCase(resourceTypes.Item(i).Name) Then
									describe = i
									Exit For
								EndIf
							Next
							If describe = -1 Then
								iErrors += 1
								Print "Error: Unknown resource type '"; sToken(1); "' at line "; Str(iLineNumber)
							EndIf
						EndIf
					Else
						Print "Warning: duplicated 'Describe' statement (duplicate is ignored) at line "; Str(iLineNumber)
					EndIf

				ElseIf LCase(sToken(0)) = "section" Then
					If curSection = -1 Then
						If iSize <> 2 Then
							iErrors += 1
							Print "Error: Argument count missmatch ('Section' accepts 1 argument, "; Str(iSize) ;" found) at line "; Str(iLineNumber)
						ElseIf describe = -1 Then
							iErrors += 1
							Print "Error:  'Describe' statement must precede any 'Section' blocks at line "; Str(iLineNumber)
						Else
							curSection = resourceTypes.Item(describe).GetSection(Mid(sToken(1), 2, Len(sToken(1)) - 2))
							If curSection = -1 Then
								iErrors += 1
								Print "Error: Unknown section """; sToken(1) ;""" at line "; Str(iLineNumber)
							EndIf
						EndIf
					EndIf

				Else

					If describe = -1 Then
						iErrors += 1
						Print "Error: Statement found but no valid 'Describe' statement detected at line "; Str(iLineNumber)
					ElseIf curSection = -1 Then
						iErrors += 1
						Print "Error: Statement cannot be outside section at line "; Str(iLineNumber)
					Else

						If LCase(sToken(0)) = "end" And iSize = 2 Then
							If LCase(sToken(1)) = "section" Then
								If curSection = -1 Then
									iErrors += 1
									Print "Error: 'End Section' without corresponding 'Section' at line "; Str(iLineNumber)
								Else
									curSection = -1
								EndIf
							EndIf
						EndIf

						If curSection <> - 1 Then
							If resourceTypes.Item(describe).Parse(sToken(), iLineNumber) = 0 Then
								iErrors += 1
							EndIf
						EndIf

					EndIf

				EndIf

				If iErrors >= MAXIMUM_NUMBER_OF_ERRORS Then
					Print "Too much errors, aborting."
					End CODE_TOO_MUCH_ERRORS
				EndIf

			EndIf

		Wend

		If describe <> -1 And curSection <> -1 Then
			Print "Error: Unexpected End-Of-File, expecting 'End Section' at line "; Str(iLineNumber)
		EndIf

		Close fn

		If describe <> -1 And curSection = -1 Then

			If Len(outputFile) = 0 Then
				outputFile = ReplaceExt(inputFile, resourceTypes.Item(describe).Extension)
			EndIf

			If resourceTypes.Item(describe).Compile( inputFile, outputFile ) Then
				Print inputFile; " successfuly compiled to "; outputFile
			EndIf

		EndIf

	Else
		Print "Error: Failed to open input file ("; inputFile ;")"
		End CODE_CANT_OPEN
	EndIf

EndIf

End CODE_OK



Sub RegisterResourceType(ByRef resType As ResType)

	resourceTypes.Add resType

End Sub