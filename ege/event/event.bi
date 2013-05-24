'
' -------------------------------------------------------------------------------------------------------------------
'
'	This file is part of EliteGameEngine source distribution
'
' -------------------------------------------------------------------------------------------------------------------
'
'	#defines:
'
'		EVENT_EXPAND_FACTOR size
'			- use this symbol to #define default expand factor used when expanding internal handler array
'             size (integer) defaults to 2
'
'	#macros:
'
'		SetEventExpandFactor( size )
'			- use this #macro to change EVENT_EXPAND_FACTOR value (which will be applied to all new Events)
'
'
'		ResetEventExpandFactor()
'			- reset EVENT_EXPAND_FACTOR to it's default value (value set with EVENT_EXPAND_FACTOR #define)
'
'
'		SimpleEvent( event_name )
'			- creates simple event (event without arguments)
'
'
'		CreateEvent( event_name, ( [identifier [, ...]] ), ([[ByRef | ByVal] identifier As Datatype [, ...]]) )
'
'			- declares event object
'
'			event_name 
'				- name of the event (type of the event declared will have 'Event' appended to event_name)
'
'			( [identifier [, ...]] ) 
'				- list of argument names (types and ByRef/ByVal MUST NOT be in this list)
'
'			([[ByRef | ByVal] identifier As Datatype [, ...]])
'				- list of argument names together with their types and ByRef/ByVal
'				  names in this list MUST match those in previous list 
'
'			for example:
'
'				CreateEvent( onMove, (x, y), (x As Single, y As Single) )
'
'			will create following:
'
'				Type onMoveEventHandler As Sub(x As Single, y As Single) 
'
'				Type onMoveEvent
'	
'					Sub Attach(handler As onMoveEventHandler)		' attaches event handler
'					Operator +=(handler As onMoveEventHandler)		' alias of Attach
'
'					Sub Deattach(handler As onMoveEventHandler)		' deattaches event handler
'					Operator -=(handler As onMoveEventHandler)		' alias of Deattach
'
'					Sub Raise(x As Single, y As Single)				' raises event
'
'				End Type
'
'
'		SharedSimpleEvent( event_name )
'			- same as SimpleEvent but also declares shared variable with name set to event_name
'
'
'		SharedEvent( event_name, ( [identifier [, ...]] ), ([[ByRef | ByVal] identifier As Datatype [, ...]]) )
'			- same as CreateEvent but also declares shared variable with name set to event_name
'
'

#Ifndef __EGE_EVENT_BI__
#Define __EGE_EVENT_BI__

	#Ifndef EVENT_EXPAND_FACTOR
	#Define EVENT_EXPAND_FACTOR	2
	#EndIf
	
	#Macro SetEventExpandFactor(NEW_EXPAND_FACTOR)
		
		#Ifdef __EVENT_EXPAND_FACTOR
			
			#Undef __EVENT_EXPAND_FACTOR
			
		#EndIf
		
		#Define __EVENT_EXPAND_FACTOR NEW_EXPAND_FACTOR
		
	#EndMacro
	
	#Macro ResetEventExpandFactor()
		
		SetEventExpandFactor( EVENT_EXPAND_FACTOR )
		
	#EndMacro
	
	
	ResetEventExpandFactor()
	

	#Macro _CreateEvent(EVENT_NAME, HANDLER_ARGUMENT_NAMES, HANDLER_ARGUMENT_LIST, IMPLEMENT)
		
		#Ifndef __EGE_EVENT_##EVENT_NAME##__
		#Define __EGE_EVENT_##EVENT_NAME##__
			
			Type EVENT_NAME##EventHandler As Sub##HANDLER_ARGUMENT_LIST
			
			Type EVENT_NAME##Event
				
				Public:
					
					Declare Sub Attach(handler As EVENT_NAME##EventHandler)
					Declare Operator +=(handler As EVENT_NAME##EventHandler)
					
					Declare Sub Deattach(handler As EVENT_NAME##EventHandler)
					Declare Operator -=(handler As EVENT_NAME##EventHandler)
					
					Declare Sub Raise##HANDLER_ARGUMENT_LIST
					
					Declare Constructor
					Declare Destructor
				
				Private:
					
					As Any Pointer							mutex
					As EVENT_NAME##EventHandler Pointer		handler = NullPtr
					As Integer								iCount 	= 0
					As Integer								iSize 	= 0
					
			End Type
			
			#If IMPLEMENT
			
			'
			' on the beginning, lets create mutex for thread safety
			'
			Constructor EVENT_NAME##Event
				
				This.mutex = MutexCreate
				
			End Constructor
			
			'
			' before we die, we release all memory we occupied during the lifetime
			'
			Destructor EVENT_NAME##Event
			
				MutexLock This.mutex
					
					If This.iSize > 0 Then DeAllocate This.handler
				
				MutexUnLock This.mutex
				
				MutexDestroy This.mutex
				
			End Destructor
			
			'
			' attaches event handler
			'
			Sub EVENT_NAME##Event.Attach(handler As EVENT_NAME##EventHandler)
				
				Dim ptrTemp As EVENT_NAME##EventHandler Pointer
				
				MutexLock This.mutex
				
					If This.iSize = This.iCount Then
						
						ptrTemp = ReAllocate(This.handler, (This.iSize + __EVENT_EXPAND_FACTOR) * SizeOf(EVENT_NAME##EventHandler))
						
						If ptrTemp = 0 Then
							
							MutexUnLock This.mutex
							
							Error 4 ' We have run out of memory! SCREEEEAM!!
	
						EndIf
						
						This.iSize += EVENT_EXPAND_FACTOR
						
						This.handler = ptrTemp
						
					EndIf
					
					This.iCount += 1
					
					This.handler[This.iCount - 1] = handler					
				
				MutexUnLock This.mutex
				
			End Sub
			
			'
			' shorthand version of Attach
			'
			Operator EVENT_NAME##Event.+=(handler As EVENT_NAME##EventHandler)
				
				This.Attach handler
				
			End Operator
			
			
			'
			' deattaches event handler
			'
			Sub EVENT_NAME##Event.Deattach(handler As EVENT_NAME##EventHandler)
				
				MutexLock This.mutex
					
					For i As Integer = 0 To This.iCount - 1
						
						If This.handler[i] = handler Then
							
							This.iCount -= 1
							
							For k As Integer = i To This.iCount - 1
								
								This.handler[k] = This.handler[k + 1]
								
							Next
							
							Exit For
							
						EndIf
		
					Next
				
				MutexUnLock This.mutex
				
			End Sub
			
			'
			' shorthand version of Deattach
			'
			Operator EVENT_NAME##Event.-=(handler As EVENT_NAME##EventHandler)
				
				This.Deattach handler
				
			End Operator
			
			
			'
			' raises event (calls all attached event handlers)
			'
			Sub EVENT_NAME##Event.Raise##HANDLER_ARGUMENT_LIST
				
				MutexLock This.mutex
					
					For i As Integer = 0 To This.iCount - 1
						
						This.handler[i]##HANDLER_ARGUMENT_NAMES
	
					Next
				
				MutexUnLock This.mutex
				
			End Sub
			
			#EndIf
		
		#EndIf
	
	#EndMacro
	
	
	#Macro CreateEvent(EVENT_NAME, HANDLER_ARGUMENT_NAMES, HANDLER_ARGUMENT_LIST)
		
		#Ifdef EGE_STATIC_LIB
			#Ifdef EGE_CUSTOM_EVENT
				_CreateEvent(EVENT_NAME, HANDLER_ARGUMENT_NAMES, HANDLER_ARGUMENT_LIST, 1)
			#Else
				_CreateEvent(EVENT_NAME, HANDLER_ARGUMENT_NAMES, HANDLER_ARGUMENT_LIST, 0)
			#EndIf
		#Else
			_CreateEvent(EVENT_NAME, HANDLER_ARGUMENT_NAMES, HANDLER_ARGUMENT_LIST, 1)
		#EndIf
		
	#EndMacro
	
	#Macro CreateCustomEvent(EVENT_NAME, HANDLER_ARGUMENT_NAMES, HANDLER_ARGUMENT_LIST)
		
		#Define EGE_CUSTOM_EVENT
		
		CreateEvent(EVENT_NAME, HANDLER_ARGUMENT_NAMES, HANDLER_ARGUMENT_LIST)
		
		#Undef EGE_CUSTOM_EVENT
		
	#EndMacro
	
	
	#Macro SimpleEvent(EVENT_NAME)
		
		#Ifndef __EGE_EVENT_##EVENT_NAME##__
		#Define __EGE_EVENT_##EVENT_NAME##__
			
			CreateEvent( __SIMPLE_ , () , () )
			
			#Define EVENT_NAME##Event __SIMPLE_Event
			#Define EVENT_NAME##EventHandler __SIMPLE_EventHandler
		
		#EndIf
			
	#EndMacro
	
	#Macro CustomSimpleEvent(EVENT_NAME)
		
		#Define EGE_CUSTOM_EVENT
		
		SimpleEvent(EVENT_NAME)
		
		#Undef EGE_CUSTOM_EVENT
		
	#EndMacro
	
	
	#Macro SharedEvent(EVENT_NAME, HANDLER_ARGUMENT_NAMES, HANDLER_ARGUMENT_LIST)
		
		CreateEvent(EVENT_NAME, HANDLER_ARGUMENT_NAMES, HANDLER_ARGUMENT_LIST)
		
		Dim Shared EVENT_NAME As EVENT_NAME##Event
		
	#EndMacro
	
	#Macro CustomSharedEvent(EVENT_NAME, HANDLER_ARGUMENT_NAMES, HANDLER_ARGUMENT_LIST)
		
		CreateCustomEvent(EVENT_NAME, HANDLER_ARGUMENT_NAMES, HANDLER_ARGUMENT_LIST)
		
		Dim Shared EVENT_NAME As EVENT_NAME##Event
		
	#EndMacro
	
	#Macro SharedSimpleEvent(EVENT_NAME)
		
		SimpleEvent(EVENT_NAME)
		
		Dim Shared EVENT_NAME As EVENT_NAME##Event
		
	#EndMacro
	
	#Macro CustomSharedSimpleEvent(EVENT_NAME)
		
		CustomSimpleEvent(EVENT_NAME)
		
		Dim Shared EVENT_NAME As EVENT_NAME##Event
		
	#EndMacro
	
	SimpleEvent( ____ ) ' needed to fix namespace conflicts
	
#EndIf	