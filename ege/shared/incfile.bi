'
'
'	IncFile and IncFileEx macros by voodooattack
'
'

#Ifndef INCFILE_BI
#Define INCFILE_BI

	#Macro IncFileEx(label, file, sectionName, attr)
		#if __FUNCTION__ <> "__FB_MAINPROC__"
	   
		    Dim label As Const Ubyte Ptr = Any
		    Dim label##_len As Uinteger = Any
		   
		    #if __FB_DEBUG__
		        asm jmp .LT_END_OF_FILE_##label##_DEBUG_JMP
		    #else
		        ' Switch to/Create the specified section
		        #if attr = ""
		            asm .section sectionName
		        #else
		            asm .section sectionName, attr
		        #endif
		    #endif
	   
		    ' Assign a label to the beginning of the file
		    asm .LT_START_OF_FILE_##label#:
		    asm __##label##__start = .
		    ' Include the file
		    asm .incbin ##file
		    ' Mark the end of the the file
		    asm __##label##__len = . - __##label##__start
		    asm .LT_END_OF_FILE_##label:
		    ' Pad it with a NULL Integer (harmless, yet useful for text files)
		    asm .LONG 0
			#if __FB_DEBUG__
			    asm .LT_END_OF_FILE_##label##_DEBUG_JMP:
			#else
			    ' Switch back to the .text (code) section               
			    asm .section .text
			    asm .balign 16
			#endif
	    	asm .LT_SKIP_FILE_##label:
	    	asm lea eax, .LT_START_OF_FILE_##label#
	    	asm mov dword Ptr [label], eax
	    	asm mov dword Ptr [label##_len], __##label##__len
		#else
	
		    Extern "c"
		    Extern label As Ubyte Ptr
		    Extern label##_len As Uinteger
		    End Extern
		   
		    #if __FB_DEBUG__
		        asm jmp .LT_END_OF_FILE_##label##_DEBUG_JMP
		    #else
		        ' Switch to/create the specified section
		        #if attr = ""
		            asm .section sectionName
		        #else
		            asm .section sectionName, attr
		        #endif
		    #endif
	   
		    ' Assign a label to the beginning of the file
		    asm .LT_START_OF_FILE_##label#:
		    asm __##label##__start = .
		    ' Include the file
		    asm .incbin ##file
		    ' Mark the end of the the file
		    asm __##label##__len = . - __##label##__start
		    asm .LT_END_OF_FILE_##label:
		    ' Pad it with a NULL Integer (harmless, yet useful for text files)
		    asm .LONG 0
		    asm label:
		    asm .int .LT_START_OF_FILE_##label#
		    asm label##_len:
		    asm .int __##label##__len
			#if __FB_DEBUG__
			    asm .LT_END_OF_FILE_##label##_DEBUG_JMP:
			#else
			    ' Switch back to the .text (code) section               
			    asm .section .text
			    asm .balign 16
			#endif
	    	asm .LT_SKIP_FILE_##label:
		#endif       
	#EndMacro
	
	#Macro IncFile(label, file)
	    IncFileEx(label, file, .data, "")        'Use the .data (storage) section (SHARED)
	#EndMacro

#EndIf