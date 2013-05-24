
''
''
''	DynamicArray datatype, by Aleksandar Ruzicic
''
''

#Ifndef __DYNARRAY_BI__
#Define __DYNARRAY_BI__
	
	#Macro DefineDynamicArrayType(_TYPE_)
		
		#Ifndef __DYNARRAY_BI_##_TYPE_##__
		#Define __DYNARRAY_BI_##_TYPE_##__
		
		Type _TYPE_##ArrayIterator As Function(ByRef Index As UInteger, ByRef Value As _TYPE_, uParam As Any Pointer = 0) As Integer
		Type _TYPE_##ArrayCompareProc As Function(ByRef a As _TYPE_, ByRef b As _TYPE_) As Integer 

		
		Type _TYPE_##Array
			
			Public:
			
				Declare Constructor
				Declare Destructor
				
				Declare Function Add(ByRef Value As _TYPE_) As _TYPE_ Pointer
				Declare Function Add As _TYPE_ Pointer
				Declare Sub Remove(Index As UInteger)
			
				Declare Sub ReDim(newSize As UInteger, preserveValues As Integer = 0)
				
				Declare Property Item(Index As UInteger) As _TYPE_
				Declare Property Item(Index As UInteger, Value As _TYPE_)
				
				Declare Function PeekAt(Index As UInteger) As _TYPE_ Pointer
				
				Declare Property ItemCount As UInteger
				
				Declare Function Iterate(iterator As _TYPE_##ArrayIterator, param As Any Pointer = 0, safe As Integer = Not 0) As Integer
				
				Declare Sub Sort(proc As _TYPE_##ArrayCompareProc) 
				
				ExpandFactor	As UInteger = 10 ' for how much items is array expanded when needed 
			
			Private:
			
				Declare Sub doSort(proc As _TYPE_##ArrayCompareProc, l As Integer, r As Integer)
			
				Size	As UInteger = 0
				Count	As UInteger = 0
				
				mutex	As Any Pointer
		
				pItem	As _TYPE_ Pointer
		
		End Type
		
		'' implementation
		
		'' create mutex to use for thread safety
		Constructor _TYPE_##Array
			
			This.mutex = MutexCreate
			
		End Constructor
		
		'' free memory on end
		Destructor _TYPE_##Array
			
			DeAllocate This.pItem
			
			MutexDestroy This.mutex
		
		End Destructor
		
		'' adds value to the array
		Function _TYPE_##Array.Add(ByRef Value As _TYPE_) As _TYPE_ Pointer
			
			Dim ptrTemp As _TYPE_ Pointer
			
			MutexLock This.mutex
			
			If This.Size = This.Count Then
				
				ptrTemp = ReAllocate(This.pItem, (This.Size + This.ExpandFactor) * SizeOf(_TYPE_))
				
				If ptrTemp = 0 Then
					
					MutexUnLock This.mutex
					
					Error 4 ' Out of memory
					
					Return 0
					
				EndIf
				
				This.Size += This.ExpandFactor
				
				This.pItem = ptrTemp
				
			EndIf
			
			This.Count += 1
			
			This.pItem[This.Count - 1] = Value
			
			Function = VarPtr(This.pItem[This.Count - 1])
			
			MutexUnLock This.mutex
			
		End Function
		
		'' adds an "empty" value (default value for the array's type) to the array
		Function _TYPE_##Array.Add As _TYPE_ Pointer
			
			Dim ptrTemp As _TYPE_ Pointer
			
			MutexLock This.mutex
			
			If This.Size = This.Count Then
				
				ptrTemp = ReAllocate(This.pItem, (This.Size + This.ExpandFactor) * SizeOf(_TYPE_))
				
				If ptrTemp = 0 Then
					
					MutexUnLock This.mutex
					
					Error 4 ' Out of memory
					
					Return 0
					
				EndIf
				
				This.Size += This.ExpandFactor
				
				This.pItem = ptrTemp
				
			EndIf
			
			' need to zero fill memory, cuz reallocate wont do that
			For i As Integer = 0 To SizeOf(_TYPE_)
				*(Cast(Byte Pointer, VarPtr(This.pItem[This.Count])) + i) = 0
			Next
			
			This.Count += 1
			
			Function = VarPtr(This.pItem[This.Count - 1])
			
			MutexUnLock This.mutex
			
		End Function
		
		'' removes value from array
		Sub _TYPE_##Array.Remove(Index As UInteger)
			
			MutexLock This.mutex
			
			If Index >= 0 And Index < This.Count Then
				
				For i As UInteger = Index To This.Count - 2
					
					This.pItem[i] = This.pItem[i + 1]
					
				Next
				
				This.Count -= 1
				
			Else
				
				MutexUnLock This.mutex
				
				Error 6 ' Out of bounds array access
				
				Return
				
			EndIf
			
			MutexUnLock This.mutex
			
		End Sub
		
		'' redimensions array (with option to preserve values)
		Sub _TYPE_##Array.ReDim(newSize As UInteger, preserveValues As Integer = 0)
			
			Dim ptrTemp As _TYPE_ Pointer
			
			MutexLock This.mutex
			
			This.Size = newSize
			
			If preserveValues Then
				
				ptrTemp = ReAllocate(This.pItem, newSize * SizeOf(_TYPE_)) 
				
				If ptrTemp = 0 Then
					
					MutexUnLock This.mutex
					
					Error 4 ' Out of memory
					
					Return					
					
				EndIf
				
				If This.Size < This.Count Then This.Count = This.Size
				
				This.pItem = ptrTemp
				
			Else
				
				ptrTemp = Allocate(newSize * SizeOf(_TYPE_))
				
				If ptrTemp = 0 Then
					
					MutexUnLock This.mutex
					
					Error 4 ' Out of memory
					
					Return
					
				EndIf
				
				This.Count = 0
				
				DeAllocate This.pItem
				
				This.pItem = ptrTemp
				
			EndIf
			
			MutexUnLock This.mutex
			
		End Sub

		'' returns array item
		Property _TYPE_##Array.Item(Index As UInteger) As _TYPE_
			
			MutexLock This.mutex
			
			If Index >= 0 And Index < This.Count Then
				
				Property = This.pItem[Index]
				
				MutexUnLock This.mutex
				
			Else
				
				MutexUnLock This.mutex
				
				Error 6 ' Out of bounds array access
								
			EndIf
		
		End Property
		
		'' sets array item
		Property _TYPE_##Array.Item(Index As UInteger, Value As _TYPE_)

			MutexLock This.mutex
			
			If Index >= 0 And Index < This.Count Then
				
				This.pItem[Index] = Value
				
				MutexUnLock This.mutex
				
			Else
				
				MutexUnLock This.mutex
				
				Error 6 ' Out of bounds array access
								
			EndIf
			
		End Property
		
		'' returns pointer to value in array
		Function _TYPE_##Array.PeekAt(Index As UInteger) As _TYPE_ Pointer
			
			MutexLock This.mutex
			
			If Index >= 0 And Index < This.Count Then
				
				Function = VarPtr(This.pItem[Index])
				
				MutexUnLock This.mutex
				
			Else
				
				MutexUnLock This.mutex
				
				Error 6 ' Out of bounds array access
								
			EndIf
			
		End Function
		
		'' returns number of items in array
		Property _TYPE_##Array.ItemCount As UInteger
			
			MutexLock This.mutex
			
			ItemCount = This.Count
			
			MutexUnLock This.mutex
			
		End Property
		
		'' iterates trough an array using iterator function
		''
		'' WARNNING: if safe is set to nonzero (default) then thread safety is guaranted but you 
		''			 CANNOT call any of array's methods/properties inside iterator function!
		''           if safe is set to zero then no thread safety is guaranted! (but then you
		''			 can call any of array's methods/properties)
		''
		'' NOTE: in iterator function which accepts index and value of current item, both
		''       arguments are pased by reference and they can be changed inside iterator,
		''       iterator function should return nonzero to stop iterating the array 
		Function _TYPE_##Array.Iterate(iterator As _TYPE_##ArrayIterator, param As Any Pointer = 0, safe As Integer = Not 0) As Integer	
			
			If safe Then MutexLock This.mutex
			
			Dim As Integer ret = 0
			
			For i As UInteger = 0 To This.Count - 1
				
				ret = iterator(i, This.pItem[i], param)
				
				If ret <> 0 Then Exit For
				
			Next
			
			If safe Then MutexUnLock This.mutex
			
			Return ret
			
		End Function
		
		
		'' sorts an array, using custom proc for comparing values
		'' NOTE: compare proc should return non-zero if A should be before B in sorted array
		Sub _TYPE_##Array.Sort(proc As _TYPE_##ArrayCompareProc)
			
			MutexLock This.mutex
			
			If This.Count > 1 Then  
				
				This.doSort proc, 0, This.Count - 1
				
			EndIf
			
			MutexUnLock This.mutex
			
		End Sub
		
		Sub _TYPE_##Array.doSort(proc As _TYPE_##ArrayCompareProc, l As Integer, r As Integer)
			
			Dim As Integer i = l, j = r
			Dim As _TYPE_ v = This.pItem[l + Int(Rnd * (r - l + 1))], t
			
			Do
				While proc(This.pItem[i], v)
					i += 1
				Wend
				
				While proc(v, This.pItem[j])
					j -= 1
				Wend
				
				If i <= j Then
					t = This.pItem[i]
					This.pItem[i] = This.pItem[j]
					This.pItem[j] = t
					i += 1
					j -= 1
				EndIf
				
			Loop Until i > j
			
			If l < j Then This.doSort(proc, l, j)
			If i < r Then This.doSort(proc, i, r)
			
		End Sub
		
		#EndIf		
	
	#EndMacro

#EndIf
