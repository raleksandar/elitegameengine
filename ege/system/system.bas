'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __EGE_SYSTEM_BAS__
#Define __EGE_SYSTEM_BAS__
	
	#If Defined(__FB_WIN32__)
		
		IncludeSource( "win32.bas" )
		
'		#ElseIf Defined(__FB_LINUX__)
		
'			IncludeSource( "linux.bas" )
	
	#Else
		
		IncludeSource( "unsupported.bas" )
				
	#EndIf 

#EndIf
