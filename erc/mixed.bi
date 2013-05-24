'
' -------------------------------------------------------------------------------------------------
'
'	This file is part of EliteResource Compiler source distribution
'
' -------------------------------------------------------------------------------------------------
'
#Ifndef __MIXED_TYPE__
#Define __MIXED_TYPE__
    
    #Macro MixedDeclareOperators(_TYPE_)
        Declare Operator Cast As _TYPE_
        Declare Operator Let(value As _TYPE_)
        Declare Operator +=(value As _TYPE_)
        Declare Operator -=(value As _TYPE_)
        Declare Operator *=(value As _TYPE_)
        Declare Operator /=(value As _TYPE_)
        Declare Operator \=(value As _TYPE_)
        Declare Operator ^=(value As _TYPE_)
        Declare Operator Mod=(value As _TYPE_)
        Declare Operator Shl=(value As _TYPE_)
        Declare Operator Shr=(value As _TYPE_)
        Declare Operator And=(value As _TYPE_)
        Declare Operator Or=(value As _TYPE_)
        Declare Operator Xor=(value As _TYPE_)
        Declare Operator Imp=(value As _TYPE_)
        Declare Operator Eqv=(value As _TYPE_)    
    #EndMacro
    
    #Macro MixedImplementAssignmentOperators(_TYPE_)
        Operator Mixed.+=(value As _TYPE_)
            This = Cast(_TYPE_, This) + value
        End Operator
        Operator Mixed.-=(value As _TYPE_)
            This = Cast(_TYPE_, This) - value
        End Operator
        Operator Mixed.*=(value As _TYPE_)
            This = Cast(_TYPE_, This) * value
        End Operator
        Operator Mixed./=(value As _TYPE_)
            This = Cast(_TYPE_, This) / value
        End Operator    
        Operator Mixed.\=(value As _TYPE_)
            This = Cast(_TYPE_, This) \ value
        End Operator    
        Operator Mixed.^=(value As _TYPE_)
            This = Cast(_TYPE_, This) ^ value
        End Operator    
        Operator Mixed.Mod=(value As _TYPE_)
            This = Cast(_TYPE_, This) Mod value
        End Operator    
        Operator Mixed.Shl=(value As _TYPE_)
            This = Cast(_TYPE_, This) Shl value
        End Operator    
        Operator Mixed.Shr=(value As _TYPE_)
            This = Cast(_TYPE_, This) Shr value
        End Operator    
        Operator Mixed.And=(value As _TYPE_)
            This = Cast(_TYPE_, This) And value
        End Operator    
        Operator Mixed.Or=(value As _TYPE_)
            This = Cast(_TYPE_, This) Or value
        End Operator    
        Operator Mixed.Xor=(value As _TYPE_)
            This = Cast(_TYPE_, This) Xor value
        End Operator    
        Operator Mixed.Imp=(value As _TYPE_)
            This = Cast(_TYPE_, This) Imp value
        End Operator    
        Operator Mixed.Eqv=(value As _TYPE_)
            This = Cast(_TYPE_, This) Eqv value
        End Operator        
    #EndMacro
    
    #Macro MixedImplementBinaryOperator(_OP_)
    Operator _OP_(ByRef lhs As Mixed, ByRef rhs As Mixed) As Mixed
        If lhs.TypeId < fbInteger Or rhs.TypeId < fbInteger Then
            Return CDbl(lhs) _OP_ CDbl(rhs)
        Else
            Return CInt(lhs) _OP_ CInt(rhs)
        EndIf 
    End Operator
    #EndMacro
    
    
    Enum MixedType
        fbEmpty
        fbString
        fbDouble
        fbSingle
        fbLongInt
        fbLong
        fbInteger
        fbShort
        fbByte
        fbAnyPointer
    End Enum
    
    Type Mixed
        
        Public:
        
            Declare Destructor
        
            Declare Property TypeId As MixedType
            
            Declare Operator Cast As String
            Declare Operator Let(value As String)
            Declare Operator +=(value As String)
            Declare Operator &=(value As String)
            
            MixedDeclareOperators(Double)
            MixedDeclareOperators(Single)
            MixedDeclareOperators(LongInt)
            MixedDeclareOperators(Long)
            MixedDeclareOperators(Integer)
            MixedDeclareOperators(Short)
            MixedDeclareOperators(Byte)
            
            Declare Operator Cast As Any Pointer
            Declare Operator Let(value As Any Pointer)
        
        Private:
        
            StoredType    As MixedType    = fbEmpty
            StoredData    As Any Pointer    = 0

    End Type
    
    Destructor Mixed
        If This.StoredType <> fbEmpty And this.StoredType <> fbAnyPointer Then
            DeAllocate This.StoredData
        EndIf
    End Destructor
    
    Property Mixed.TypeId As MixedType
        Return This.StoredType
    End Property
    
    Operator Mixed.Cast As String
        Select Case This.StoredType
            Case fbEmpty: Return ""
            Case fbString: Return *Cast(String Pointer, This.StoredData)
            Case fbDouble: Return Str(*Cast(Double Pointer, This.StoredData))
            Case fbSingle: Return Str(*Cast(Single Pointer, This.StoredData))
            Case fbLongInt: Return Str(*Cast(LongInt Pointer, This.StoredData))
            Case fbLong: Return Str(*Cast(Long Pointer, This.StoredData))
            Case fbInteger: Return Str(*Cast(Integer Pointer, This.StoredData))
            Case fbShort: Return Str(*Cast(Short Pointer, This.StoredData))
            Case fbByte: Return Str(*Cast(Byte Pointer, This.StoredData))
            Case fbAnyPointer: Return *Cast(String Pointer, This.StoredData)
        End Select
    End Operator
    Operator Mixed.Let(Value As String)
        If This.StoredType <> fbEmpty And This.StoredType <> fbAnyPointer Then
            DeAllocate This.StoredData
        EndIf
        This.StoredType = fbString
        This.StoredData = Allocate(SizeOf(String))
        *Cast(String Pointer, This.StoredData) = value
    End Operator
    Operator Mixed.+=(value As String)
        This = Cast(String, This) & value
    End Operator
    Operator Mixed.&=(value As String)
        This = Cast(String, This) & value
    End Operator
    
    Operator Mixed.Cast As Double
        Select Case This.StoredType
            Case fbEmpty: Return 0
            Case fbString: Return CDbl(*Cast(String Pointer, This.StoredData))
            Case fbDouble: Return *Cast(Double Pointer, This.StoredData)
            Case fbSingle: Return CDbl(*Cast(Single Pointer, This.StoredData))
            Case fbLongInt: Return CDbl(*Cast(LongInt Pointer, This.StoredData))
            Case fbLong: Return CDbl(*Cast(Long Pointer, This.StoredData))
            Case fbInteger: Return CDbl(*Cast(Integer Pointer, This.StoredData))
            Case fbShort: Return CDbl(*Cast(Short Pointer, This.StoredData))
            Case fbByte: Return CDbl(*Cast(Byte Pointer, This.StoredData))
            Case fbAnyPointer: Return *Cast(Double Pointer, This.StoredData)
        End Select
    End Operator
    Operator Mixed.Let(Value As Double)
        If This.StoredType <> fbEmpty And This.StoredType <> fbAnyPointer Then
            DeAllocate This.StoredData
        EndIf
        This.StoredType = fbDouble
        This.StoredData = Allocate(SizeOf(Double))
        *Cast(Double Pointer, This.StoredData) = value
    End Operator
    MixedImplementAssignmentOperators(Double)
    
    Operator Mixed.Cast As Single
        Select Case This.StoredType
            Case fbEmpty: Return 0
            Case fbString: Return CSng(*Cast(String Pointer, This.StoredData))
            Case fbDouble: Return CSng(*Cast(Double Pointer, This.StoredData))
            Case fbSingle: Return *Cast(Single Pointer, This.StoredData)
            Case fbLongInt: Return CSng(*Cast(LongInt Pointer, This.StoredData))
            Case fbLong: Return CSng(*Cast(Long Pointer, This.StoredData))
            Case fbInteger: Return CSng(*Cast(Integer Pointer, This.StoredData))
            Case fbShort: Return CSng(*Cast(Short Pointer, This.StoredData))
            Case fbByte: Return CSng(*Cast(Byte Pointer, This.StoredData))
            Case fbAnyPointer: Return *Cast(Single Pointer, This.StoredData)
        End Select
    End Operator
    Operator Mixed.Let(Value As Single)
        If This.StoredType <> fbEmpty And This.StoredType <> fbAnyPointer Then
            DeAllocate This.StoredData
        EndIf
        This.StoredType = fbSingle
        This.StoredData = Allocate(SizeOf(Single))
        *Cast(Single Pointer, This.StoredData) = value
    End Operator
    MixedImplementAssignmentOperators(Single)
    
    Operator Mixed.Cast As LongInt
        Select Case This.StoredType
            Case fbEmpty: Return 0
            Case fbString: Return CLngInt(*Cast(String Pointer, This.StoredData))
            Case fbDouble: Return CLngInt(*Cast(Double Pointer, This.StoredData))
            Case fbSingle: Return CLngInt(*Cast(Single Pointer, This.StoredData))
            Case fbLongInt: Return *Cast(LongInt Pointer, This.StoredData)
            Case fbLong: Return CLngInt(*Cast(Long Pointer, This.StoredData))
            Case fbInteger: Return CLngInt(*Cast(Integer Pointer, This.StoredData))
            Case fbShort: Return CLngInt(*Cast(Short Pointer, This.StoredData))
            Case fbByte: Return CLngInt(*Cast(Byte Pointer, This.StoredData))
            Case fbAnyPointer: Return *Cast(LongInt Pointer, This.StoredData)
        End Select
    End Operator
    Operator Mixed.Let(Value As LongInt)
        If This.StoredType <> fbEmpty And This.StoredType <> fbAnyPointer Then
            DeAllocate This.StoredData
        EndIf
        This.StoredType = fbLongInt
        This.StoredData = Allocate(SizeOf(LongInt))
        *Cast(LongInt Pointer, This.StoredData) = value
    End Operator
    MixedImplementAssignmentOperators(LongInt)
    
    Operator Mixed.Cast As Long
        Select Case This.StoredType
            Case fbEmpty: Return 0
            Case fbString: Return CLng(*Cast(String Pointer, This.StoredData))
            Case fbDouble: Return CLng(*Cast(Double Pointer, This.StoredData))
            Case fbSingle: Return CLng(*Cast(Single Pointer, This.StoredData))
            Case fbLongInt: Return CLng(*Cast(LongInt Pointer, This.StoredData))
            Case fbLong: Return *Cast(Long Pointer, This.StoredData)
            Case fbInteger: Return CLng(*Cast(Integer Pointer, This.StoredData))
            Case fbShort: Return CLng(*Cast(Short Pointer, This.StoredData))
            Case fbByte: Return CLng(*Cast(Byte Pointer, This.StoredData))
            Case fbAnyPointer: Return *Cast(Long Pointer, This.StoredData)
        End Select
    End Operator
    Operator Mixed.Let(Value As Long)
        If This.StoredType <> fbEmpty And This.StoredType <> fbAnyPointer Then
            DeAllocate This.StoredData
        EndIf
        This.StoredType = fbLong
        This.StoredData = Allocate(SizeOf(Long))
        *Cast(Long Pointer, This.StoredData) = value
    End Operator
    MixedImplementAssignmentOperators(Long)
    
    Operator Mixed.Cast As Integer
        Select Case This.StoredType
            Case fbEmpty: Return 0
            Case fbString: Return CInt(*Cast(String Pointer, This.StoredData))
            Case fbDouble: Return CInt(*Cast(Double Pointer, This.StoredData))
            Case fbSingle: Return CInt(*Cast(Single Pointer, This.StoredData))
            Case fbLongInt: Return CInt(*Cast(LongInt Pointer, This.StoredData))
            Case fbLong: Return CInt(*Cast(Long Pointer, This.StoredData))
            Case fbInteger: Return *Cast(Integer Pointer, This.StoredData)
            Case fbShort: Return CInt(*Cast(Short Pointer, This.StoredData))
            Case fbByte: Return CInt(*Cast(Byte Pointer, This.StoredData))
            Case fbAnyPointer: Return *Cast(Integer Pointer, This.StoredData)
        End Select
    End Operator
    Operator Mixed.Let(Value As Integer)
        If This.StoredType <> fbEmpty And This.StoredType <> fbAnyPointer Then
            DeAllocate This.StoredData
        EndIf
        This.StoredType = fbInteger
        This.StoredData = Allocate(SizeOf(Integer))
        *Cast(Integer Pointer, This.StoredData) = value
    End Operator
    MixedImplementAssignmentOperators(Integer)
    
    Operator Mixed.Cast As Short
        Select Case This.StoredType
            Case fbEmpty: Return 0
            Case fbString: Return CShort(*Cast(String Pointer, This.StoredData))
            Case fbDouble: Return CShort(*Cast(Double Pointer, This.StoredData))
            Case fbSingle: Return CShort(*Cast(Single Pointer, This.StoredData))
            Case fbLongInt: Return CShort(*Cast(LongInt Pointer, This.StoredData))
            Case fbLong: Return CShort(*Cast(Long Pointer, This.StoredData))
            Case fbInteger: Return CShort(*Cast(Integer Pointer, This.StoredData))
            Case fbShort: Return *Cast(Short Pointer, This.StoredData)
            Case fbByte: Return CShort(*Cast(Byte Pointer, This.StoredData))
            Case fbAnyPointer: Return *Cast(Short Pointer, This.StoredData)
        End Select
    End Operator
    Operator Mixed.Let(Value As Short)
        If This.StoredType <> fbEmpty And This.StoredType <> fbAnyPointer Then
            DeAllocate This.StoredData
        EndIf
        This.StoredType = fbShort
        This.StoredData = Allocate(SizeOf(Short))
        *Cast(Short Pointer, This.StoredData) = value
    End Operator
    MixedImplementAssignmentOperators(Short)
    
    Operator Mixed.Cast As Byte
        Select Case This.StoredType
            Case fbEmpty: Return 0
            Case fbString: Return CByte(*Cast(String Pointer, This.StoredData))
            Case fbDouble: Return CByte(*Cast(Double Pointer, This.StoredData))
            Case fbSingle: Return CByte(*Cast(Single Pointer, This.StoredData))
            Case fbLongInt: Return CByte(*Cast(LongInt Pointer, This.StoredData))
            Case fbLong: Return CByte(*Cast(Long Pointer, This.StoredData))
            Case fbInteger: Return CByte(*Cast(Integer Pointer, This.StoredData))
            Case fbShort: Return CByte(*Cast(Short Pointer, This.StoredData))
            Case fbByte: Return *Cast(Byte Pointer, This.StoredData)
            Case fbAnyPointer: Return *Cast(Byte Pointer, This.StoredData)
        End Select
    End Operator
    Operator Mixed.Let(Value As Byte)
        If This.StoredType <> fbEmpty And This.StoredType <> fbAnyPointer Then
            DeAllocate This.StoredData
        EndIf
        This.StoredType = fbByte
        This.StoredData = Allocate(SizeOf(Byte))

        *Cast(Byte Pointer, This.StoredData) = value
    End Operator
    MixedImplementAssignmentOperators(Byte)
    
    Operator Mixed.Cast As Any Pointer
        Select Case This.StoredType
            Case fbEmpty: Return 0
            Case fbString: Return Cast(String Pointer, This.StoredData)
            Case fbDouble: Return Cast(Double Pointer, This.StoredData)
            Case fbSingle: Return Cast(Single Pointer, This.StoredData)
            Case fbLongInt: Return Cast(LongInt Pointer, This.StoredData)
            Case fbLong: Return Cast(Long Pointer, This.StoredData)
            Case fbInteger: Return Cast(Integer Pointer, This.StoredData)
            Case fbShort: Return Cast(Short Pointer, This.StoredData)
            Case fbByte: Return Cast(Byte Pointer, This.StoredData)
            Case fbAnyPointer: Return This.StoredData
        End Select
    End Operator
    Operator Mixed.Let(Value As Any Pointer)
        If This.StoredType <> fbEmpty And This.StoredType <> fbAnyPointer Then
            DeAllocate This.StoredData
        EndIf
        This.StoredType = fbAnyPointer
        This.StoredData = Allocate(SizeOf(Any Pointer))
        This.StoredData = value
    End Operator
    
    Operator -(ByRef rhs As Mixed) As Mixed
        Select Case rhs.TypeId
            Case fbEmpty:     Return 0
            Case Else:         Return -Cast(Double, rhs)
        End Select
    End Operator
    
    Operator &(ByRef lhs As Mixed, ByRef rhs As Mixed) As Mixed
        Return Str(lhs) & Str(rhs) 
    End Operator

    MixedImplementBinaryOperator(+)
    MixedImplementBinaryOperator(-)
    MixedImplementBinaryOperator(*)
    MixedImplementBinaryOperator(/)
    MixedImplementBinaryOperator(\)
    MixedImplementBinaryOperator(Mod)
    MixedImplementBinaryOperator(Shl)
    MixedImplementBinaryOperator(Shr)
    MixedImplementBinaryOperator(And)
    MixedImplementBinaryOperator(Or)
    MixedImplementBinaryOperator(Xor)
    MixedImplementBinaryOperator(Imp)
    MixedImplementBinaryOperator(Eqv)
    MixedImplementBinaryOperator(^)
    MixedImplementBinaryOperator(=)
    MixedImplementBinaryOperator(<>)
    MixedImplementBinaryOperator(<)
    MixedImplementBinaryOperator(>)
    MixedImplementBinaryOperator(<=)
    MixedImplementBinaryOperator(>=)

#EndIf