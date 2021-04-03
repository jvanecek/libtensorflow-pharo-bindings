"
Represents one of the outputs of an Operation.

A Tensor is a symbolic handle to one of the outputs of an Operation. It does not hold the values of that operation's output, but instead provides a means of computing those values in a TensorFlow tf.Session.


"
Class {
	#name : #TFTensor,
	#superclass : #FFIOpaqueObject,
	#category : #TensorFlowCore
}

{ #category : #utils }
TFTensor class >> array: values type: type into: anExternalAddressOrByteArray [
	| size index setter |
	size := self sizeForType: type.
	setter := self setterBlockFor: type.
	index := 0.
	self
		elementsOf: values
		do: [ :value | 
			setter value: anExternalAddressOrByteArray value: index * size + 1 value: value.
			index := index + 1 ]
]

{ #category : #converting }
TFTensor class >> asExternalTypeOn: aFFICallout [ 
	^ FFIOpaqueObjectType objectClass: self
]

{ #category : #utils }
TFTensor class >> elementsOf: aMultidimensionalTensor [
	| answer |
	answer := (Array new: (self sizeOf: aMultidimensionalTensor)) writeStream.
	self elementsOf: aMultidimensionalTensor do: [ :each | answer nextPut: each ].
	^ answer contents
]

{ #category : #utils }
TFTensor class >> elementsOf: tensorArray do: oneArgBlock [
	^ (tensorArray isCollection and: [ tensorArray isString not ])
		ifTrue: [ tensorArray do: [ :each | self elementsOf: each do: oneArgBlock ] ]
		ifFalse: [ oneArgBlock value: tensorArray ]
]

{ #category : #'instance creation' }
TFTensor class >> fromBooleans: values [
	^ self fromNumbers: values type: self typeBoolean
]

{ #category : #'instance creation' }
TFTensor class >> fromBools: values shape: shape [
	^ self fromNumbers: values type: self typeBoolean shape: shape
]

{ #category : #'instance creation' }
TFTensor class >> fromDoubles: values [
	^ self fromNumbers: values type: self typeDouble
]

{ #category : #'instance creation' }
TFTensor class >> fromDoubles: values shape: shape [
	^ self fromNumbers: values type: self typeDouble shape: shape
]

{ #category : #'instance creation' }
TFTensor class >> fromFloats: values [
	^ self fromNumbers: values type: self typeFloat
]

{ #category : #'instance creation' }
TFTensor class >> fromFloats: values shape: shape [
	^ self fromNumbers: values type: self typeFloat shape: shape
]

{ #category : #'instance creation' }
TFTensor class >> fromInt32: value [
	| answer |
	answer := self type: self typeInt32 shape: TensorShape scalar.
	answer data getHandle signedLongAt: 1 put: value.
	^ answer
]

{ #category : #'instance creation' }
TFTensor class >> fromInt32s: values [
	^ self fromNumbers: values type: self typeInt32
]

{ #category : #'instance creation' }
TFTensor class >> fromInt32s: values shape: shape [
	^ self fromNumbers: values type: self typeInt32 shape: shape
]

{ #category : #'instance creation' }
TFTensor class >> fromInt64: value [
	| answer |
	answer := self type: self typeInt64 shape: TensorShape scalar.
	answer data getHandle signedLongLongAt: 1 put: value.
	^ answer
]

{ #category : #'instance creation' }
TFTensor class >> fromInt64s: values [
	^ self fromNumbers: values type: self typeInt64
]

{ #category : #'instance creation' }
TFTensor class >> fromInt64s: values shape: shape [
	^ self fromNumbers: values type: self typeInt64 shape: shape
]

{ #category : #'instance creation' }
TFTensor class >> fromNumbers: values type: type [
	| shape |
	shape := self shapeOf: values.
	^ self fromNumbers: values type: type shape: shape
]

{ #category : #acccessing }
TFTensor class >> fromNumbers: values type: type shape: shape [

	| answer size count |

	size := self sizeOf: values.
	count := shape totalAmountOfElements.
	count = size
		ifFalse: [ Error signal: 'Inferred size and real size don''t match.' ].
	answer := self type: type shape: shape.
	self array: values type: type into: answer data getHandle.
	^ answer
]

{ #category : #'instance creation' }
TFTensor class >> fromString: aString [
	| answer bytesize |
	bytesize := TensorFlowCAPI current stringEncodedSize: aString.
	bytesize := bytesize.
	answer := self type: self typeString shape: TensorShape scalar bytesize: bytesize.
	
	TensorFlowCAPI current
		stringEncode: aString
		to: answer data getHandle
		size: bytesize.
	^ answer
]

{ #category : #'instance creation' }
TFTensor class >> fromStringArray: aStringArray [

	^self fromStrings: aStringArray shape: (TensorShape vectorSized: aStringArray size)
]

{ #category : #'instance creation' }
TFTensor class >> fromStringArray: aStringArray shape: shape [
	| answer sizes offsets offsetSize bytesize |
	sizes := aStringArray collect: [:each | self sizeOfString: each].
	offsetSize := self sizeForType: self typeInt64.
	bytesize := offsetSize * aStringArray size + sizes sum.
	offsets := OrderedCollection new: sizes size.
	
	sizes inject: 0 into: [:prev :each |
		offsets add: prev.
		each + prev].
	
	answer := self
		type: self typeString
		shape: shape
		bytesize: bytesize.
		
	self int64Array: offsets into: answer data getHandle.	
	
	aStringArray withIndexDo: [:each :index |
		| offset |
		offset := offsetSize * aStringArray size + (offsets at: index).
		TensorFlowCAPI current
			stringEncode: each
			to: answer data getHandle + offset
			size: bytesize - offset].
	^ answer

]

{ #category : #'instance creation' }
TFTensor class >> fromStrings: aStringArray [

	^self
		fromStrings: aStringArray
		shape: (self shapeOf: aStringArray) dimensionSizes allButLast asTensorShape
]

{ #category : #'instance creation' }
TFTensor class >> fromStrings: strings shape: shape [
	| flatten |
	flatten := self elementsOf: strings.
	^ self fromStringArray: flatten shape: shape
]

{ #category : #types }
TFTensor class >> getterBlockFor: type [
	TFTensor typeUInt8 = type ifTrue: [ ^ [ :data :offset | data unsignedByteAt: offset ] ].
	TFTensor typeInt32 = type ifTrue: [^ [:data :offset | data signedLongAt: offset]].
	TFTensor typeInt64 = type ifTrue: [^ [:data :offset | data signedLongLongAt: offset]].
	TFTensor typeFloat = type ifTrue: [^ [:data :offset | data floatAt: offset]].
	TFTensor typeDouble = type ifTrue: [^ [:data :offset | data doubleAt: offset]].
	TFTensor typeBoolean = type ifTrue: [^ [:data :offset | data booleanAt: offset]].
	^ self shouldBeImplemented 
]

{ #category : #utils }
TFTensor class >> int64Array: values into: anExternalAddressOrByteArray [
	self array: values type: self typeInt64 into: anExternalAddressOrByteArray.

]

{ #category : #'instance creation' }
TFTensor class >> new [

	^super new initialize
]

{ #category : #'instance creation' }
TFTensor class >> pi [
	^ Float pi asTensor
]

{ #category : #utils }
TFTensor class >> rankOf: aMultidimensionalArray [
	"Return the rank of a multi-dimensional Array"

	^ aMultidimensionalArray isCollection
		ifTrue: [ 1 + (self rankOf: aMultidimensionalArray first) ]
		ifFalse: [ 0 ]
]

{ #category : #types }
TFTensor class >> setterBlockFor: type [
	TFTensor typeUInt8 = type
		ifTrue: [ ^ [ :data :offset :value | data unsignedByteAt: offset put: value ] ].
	TFTensor typeInt32 = type
		ifTrue: [ ^ [ :data :offset :value | data signedLongAt: offset put: value ] ].
	TFTensor typeInt64 = type
		ifTrue: [ ^ [ :data :offset :value | data signedLongLongAt: offset put: value ] ].
	TFTensor typeFloat = type
		ifTrue: [ ^ [ :data :offset :value | data floatAt: offset put: value ] ].
	TFTensor typeDouble = type
		ifTrue: [ ^ [ :data :offset :value | data doubleAt: offset put: value ] ].
	TFTensor typeBoolean = type
		ifTrue: [ ^ [ :data :offset :value | data booleanAt: offset put: value ] ].
	^ self shouldBeImplemented
]

{ #category : #acccessing }
TFTensor class >> shapeOf: aMultidimensionalTensor [

	^aMultidimensionalTensor isCollection
		ifTrue: [
			aMultidimensionalTensor isEmpty
				ifTrue: [TensorShape vectorSized: 0]
				ifFalse: [
					TensorShape withDimensionsSized: (
						(Array with: aMultidimensionalTensor size) ,
							(self shapeOf: aMultidimensionalTensor first) dimensionSizes)]]
		ifFalse: [TensorShape scalar]
]

{ #category : #types }
TFTensor class >> sizeForType: anInteger [
	self typeFloat = anInteger ifTrue: [^4].
	self typeInt64 = anInteger ifTrue: [^8].
	self typeInt32 = anInteger ifTrue: [^4].
	self typeUInt8 = anInteger ifTrue: [^1].
	self typeDouble = anInteger ifTrue: [^8].
	self typeBoolean = anInteger ifTrue: [^1].

"
8
		UInt8 4
		Int8 6
		QInt8 11
		QUInt8 12

16
		Int16 5
		BFloat16 14
		QInt16 15
		QUInt16 16
		UInt16 17
		Half 19

32
		Float 1
		Int32 3
		QInt32 13

64
		Double 2
		Complex64 8
		Int64 9

128
		Complex128 18

		String 7
		Resource 20).

		Bool 10
"


	^ self shouldBeImplemented.
]

{ #category : #utils }
TFTensor class >> sizeOf: aMultidimensionalArray [
	"Return the size of a multi-dimensional Array"

	^ aMultidimensionalArray isCollection
		ifTrue: [ aMultidimensionalArray isEmpty
				ifTrue: [ 0 ]
				ifFalse: [ aMultidimensionalArray sum: [ :each | self sizeOf: each ] ] ]
		ifFalse: [ 1 ]
]

{ #category : #utils }
TFTensor class >> sizeOfString: aString [
	^ TensorFlowCAPI current stringEncodedSize: aString
]

{ #category : #'instance creation' }
TFTensor class >> type: anInteger shape: aTensorShape [
	" I understand dimenssions are:
		#()		-> Scalar
		#(7)		-> Unidimensional array of 7 elements
		#(7 4)		-> 7x4 elements matrix
		#(2 5 9)	-> 2x5x9 elements cube
		etc.
	"

	| bytesize elementSize |
	elementSize := self sizeForType: anInteger.
	bytesize := aTensorShape totalAmountOfElements * elementSize.
	^ self type: anInteger shape: aTensorShape bytesize: bytesize
]

{ #category : #'instance creation' }
TFTensor class >> type: anInteger shape: aTensorShape bytesize: bytesizeInteger [

	" I understand dimensions are:
		#()		-> Scalar
		#(7)		-> Unidimensional array of 7 elements
		#(7 4)		-> 7x4 elements matrix
		#(2 5 9)	-> 2x5x9 elements cube
		etc.
	"

	| externalized answer |

	externalized := FFIExternalArray externalNewType: 'int64' fromArray: aTensorShape dimensionSizes.

	answer := TensorFlowCAPI current
		allocateTensorType: anInteger
		shape: externalized getHandle
		rank: aTensorShape size
		length: bytesizeInteger.
	answer autoRelease.
	^ answer
]

{ #category : #types }
TFTensor class >> typeBFloat16 [
	^ 14
]

{ #category : #types }
TFTensor class >> typeBoolean [
	"TF_BOOL = 10"

	^ 10
]

{ #category : #types }
TFTensor class >> typeComplex128 [
	^ 18
]

{ #category : #types }
TFTensor class >> typeComplex64 [
	^ 8
]

{ #category : #types }
TFTensor class >> typeDouble [
	"TF_DOUBLE = 2"

	^ 2
]

{ #category : #types }
TFTensor class >> typeFloat [
	^ 1
]

{ #category : #types }
TFTensor class >> typeHalf [
	^ 19
]

{ #category : #types }
TFTensor class >> typeInt16 [
	^5
]

{ #category : #types }
TFTensor class >> typeInt32 [
	^ 3
]

{ #category : #types }
TFTensor class >> typeInt64 [
	^ 9
]

{ #category : #types }
TFTensor class >> typeInt8 [
	^6
]

{ #category : #types }
TFTensor class >> typeQInt16 [
	^15
]

{ #category : #types }
TFTensor class >> typeQInt32 [
	^13
]

{ #category : #types }
TFTensor class >> typeQInt8 [
	^11
]

{ #category : #types }
TFTensor class >> typeQUInt16 [
	^16
]

{ #category : #types }
TFTensor class >> typeQUInt8 [
	^12
]

{ #category : #types }
TFTensor class >> typeResource [
	^20
]

{ #category : #types }
TFTensor class >> typeString [
	^7
]

{ #category : #types }
TFTensor class >> typeUInt16 [
	^17
]

{ #category : #types }
TFTensor class >> typeUInt8 [
	^4
]

{ #category : #acccessing }
TFTensor class >> typeVariant [
	^21
]

{ #category : #comparing }
TFTensor >> = aTF_Tensor [

"We have to tests both side in order to be correct under Pharo 6.1 and Pharo 7.0"
"Because TestAsserter>>assert: actual equals: expected is not really the same between these 2 versions"

	^ self class = aTF_Tensor class and: [( handle = aTF_Tensor getHandle ) or: [aTF_Tensor getHandle = handle getHandle]]
]

{ #category : #converting }
TFTensor >> allElements [
	^ self asStream contents
]

{ #category : #converting }
TFTensor >> allFloats [
	^ self allElements
]

{ #category : #converting }
TFTensor >> allInt32s [
	^ self allElements
]

{ #category : #converting }
TFTensor >> allInt64s [
	^ self allElements
]

{ #category : #converting }
TFTensor >> allStrings [
	| total answer bytes data |
	total := self size.
	answer := WriteStream on: (Array new: total).
	bytes := self dataBytes.
	data := self data getHandle + (8 * total).
	1 to: total do: [:i |
		| offset str |
		offset := bytes unsignedLongLongAt: i - 1 * 8 + 1.
		str := self library stringDecode: data + offset.
		answer nextPut: str].
	
	^ answer contents
]

{ #category : #converting }
TFTensor >> arrayFromStream: strm shape: shape [

	^shape representsScalar
		ifTrue: [strm next]
		ifFalse: [| first tail |
			first := shape dimensionSizes first.
			tail := TensorShape withDimensionsSized: shape dimensionSizes allButFirst.
			Array streamContents: [:answer |
				first timesRepeat: [| next |
					next := self arrayFromStream: strm shape: tail.
					answer nextPut: next]]]
]

{ #category : #converting }
TFTensor >> asNumbers [
	^ self arrayFromStream: self asStream reset shape: self shape
]

{ #category : #converting }
TFTensor >> asOperationOn: aComputation [

	^ ConstantNode on: aComputation with: self
]

{ #category : #converting }
TFTensor >> asStream [
	| answer |
	answer := ReadWriteStream on: (Array new: self size).
	self elementsDo: [ :each | answer nextPut: each ].
	^ answer reset
]

{ #category : #converting }
TFTensor >> asTensor [

	^ self
]

{ #category : #accessing }
TFTensor >> byteSize [
	^ self library tensorByteSize: self
]

{ #category : #accessing }
TFTensor >> data [
	^ self library tensorData: self
]

{ #category : #iterating }
TFTensor >> dataAndOffsetsCollect: twoArgsBlock thenDo: oneArgBlock [
	| data elementSize |
	elementSize := self elementSize.
	data := self data getHandle.
	1 to: self size do: [:i |
		| value |
		value := twoArgsBlock value: data value: i-1*elementSize+1.
		oneArgBlock value: value].

]

{ #category : #accessing }
TFTensor >> dataBytes [
	^ self data getHandle structAt: 1 length: self byteSize
]

{ #category : #release }
TFTensor >> delete [
	self ignoreFinalization.
	self isNull
		ifFalse: [ self library deleteTensor: self ].
	handle := nil
]

{ #category : #accessing }
TFTensor >> elementSize [
	^ self class sizeForType: self type
]

{ #category : #iterating }
TFTensor >> elementsDo: oneArgBlock [
	self dataAndOffsetsCollect: self getterBlock thenDo: oneArgBlock
]

{ #category : #finalization }
TFTensor >> finalize [
	self delete
]

{ #category : #iterating }
TFTensor >> floatsDo: oneArgBlock [
	self dataAndOffsetsCollect: [ :data :offset | data floatAt: offset ] thenDo: oneArgBlock
]

{ #category : #accessing }
TFTensor >> getHandle [

"We need to refactor later"
^ super getHandle getHandle
]

{ #category : #iterating }
TFTensor >> getterBlock [
	^ self class getterBlockFor: self type
]

{ #category : #iterating }
TFTensor >> int32sDo: oneArgBlock [
	self dataAndOffsetsCollect: [ :data :offset | data signedLongAt: offset ] thenDo: oneArgBlock
]

{ #category : #iterating }
TFTensor >> int64sDo: oneArgBlock [
	self dataAndOffsetsCollect: [ :data :offset | data signedLongLongAt: offset ] thenDo: oneArgBlock
]

{ #category : #converting }
TFTensor >> library [
	^ TensorFlowCAPI current
]

{ #category : #accessing }
TFTensor >> numBytes [
	
	 ^ self byteSize
]

{ #category : #'not categorized' }
TFTensor >> numDims [

	^self rank
]

{ #category : #accessing }
TFTensor >> rank [
	^ self library tensorRank: self
]

{ #category : #Accessing }
TFTensor >> scalarOutput [

	self isScalar ifTrue: [^self allElements any].

	AssertionFailure signal: 'This tensor is not a scalar'
]

{ #category : #accessing }
TFTensor >> shape [

	| answer count |

	count := self rank.
	answer := WriteStream on: (Array new: count).
	1 to: count do: [:i | answer nextPut: (self sizeOn: i - 1)].
	^TensorShape withDimensionsSized: answer contents
]

{ #category : #accessing }
TFTensor >> size [

	^self shape totalAmountOfElements
]

{ #category : #accessing }
TFTensor >> sizeOn: dimension [
	^ self library tensor: self sizeOn: dimension
]

{ #category : #accessing }
TFTensor >> type [
	^ self library tensorType: self
]
