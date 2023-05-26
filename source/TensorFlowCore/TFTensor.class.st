"
Represents one of the outputs of an Operation.

A Tensor is a symbolic handle to one of the outputs of an Operation. It does not hold the values of that operation's output, but instead provides a means of computing those values in a TensorFlow tf.Session.


"
Class {
	#name : #TFTensor,
	#superclass : #ExternalStructure,
	#category : #'TensorFlowCore-Structures'
}

{ #category : #utils }
TFTensor class >> copyArrayOf: type with: values into: anExternalAddressOrByteArray [

	| index |

	index := 0.
	values singleElementsDo: [:value |
		type put: value at: index in: anExternalAddressOrByteArray.
		index := index + 1]
]

{ #category : #'instance creation' }
TFTensor class >> fromBooleans: values [

	^ self newTyped: BooleanDataType new containing: values
]

{ #category : #'instance creation' }
TFTensor class >> fromBools: values shape: shape [

	^ self newTyped: BooleanDataType new shaped: shape containing: values
]

{ #category : #'instance creation' }
TFTensor class >> fromDoubles: values [

	^ self newTyped: DoubleDataType new containing: values
]

{ #category : #'instance creation' }
TFTensor class >> fromDoubles: values shape: shape [

	^ self newTyped: DoubleDataType new shaped: shape containing: values
]

{ #category : #'instance creation' }
TFTensor class >> fromFloats: values [

	^ self newTyped: FloatDataType new containing: values
]

{ #category : #'instance creation' }
TFTensor class >> fromFloats: values shape: shape [

	^ self newTyped: FloatDataType new shaped: shape containing: values
]

{ #category : #'instance creation' }
TFTensor class >> fromInt32: value [

	^ self
		newTyped: Int32DataType new
		shaped: TensorShape scalar
		thenDo: [ :tensor | tensor data getHandle signedLongAt: 1 put: value ]
]

{ #category : #'instance creation' }
TFTensor class >> fromInt32s: values [

	^ self newTyped: Int32DataType new containing: values
]

{ #category : #'instance creation' }
TFTensor class >> fromInt32s: values shape: shape [

	^ self newTyped: Int32DataType new shaped: shape containing: values
]

{ #category : #'instance creation' }
TFTensor class >> fromInt64: value [

	^ self
		newTyped: Int64DataType new
		shaped: TensorShape scalar
		thenDo: [ :tensor | tensor data getHandle signedLongLongAt: 1 put: value ]
]

{ #category : #'instance creation' }
TFTensor class >> fromInt64s: values [

	^ self newTyped: Int64DataType new containing: values
]

{ #category : #'instance creation' }
TFTensor class >> fromInt64s: values shape: shape [

	^ self newTyped: Int64DataType new shaped: shape containing: values
]

{ #category : #'instance creation' }
TFTensor class >> fromStrings: aStringArray [

	^ self fromStrings: aStringArray shape: aStringArray inferTensorShape
]

{ #category : #'instance creation' }
TFTensor class >> fromStrings: aStringArray shape: shape [

	| flatten |

	flatten := Array
		new: aStringArray singleElementsInCollection
		streamContents: [ :stream | aStringArray singleElementsDo: [ :each | stream nextPut: each ] ].
	^ self newTyped: StringDataType new shaped: shape containing: flatten
]

{ #category : #'instance creation' }
TFTensor class >> new [

	^super new initialize
]

{ #category : #'instance creation' }
TFTensor class >> newTyped: type containing: values [

	^ self newTyped: type shaped: values inferTensorShape containing: values
]

{ #category : #'instance creation' }
TFTensor class >> newTyped: anInteger shaped: aTensorShape [

	^ self newTyped: anInteger shaped: aTensorShape thenDo: [ :tensor |  ]
]

{ #category : #'instance creation' }
TFTensor class >> newTyped: aTensorType shaped: aTensorShape bytesize: bytesizeInteger thenDo: aBlock [

	| tensor |

	tensor := TensorFlowCAPI current
		allocateTensorOf: ( TensorDomain of: aTensorType withShape: aTensorShape )
		length: bytesizeInteger.
	aBlock value: tensor.
	^ tensor
]

{ #category : #acccessing }
TFTensor class >> newTyped: type shaped: shape containing: values [

	| size count |

	size := values singleElementsInCollection.
	count := shape totalAmountOfElements.
	count = size
		ifFalse: [ Error signal: 'Inferred size and real size don''t match.' ].
	^ self
		newTyped: type
		shaped: shape
		thenDo: [ :tensor | self copyArrayOf: type with: values into: tensor data getHandle ]
]

{ #category : #'instance creation' }
TFTensor class >> newTyped: aDataType shaped: aTensorShape thenDo: aBlock [

	" I understand dimenssions are:
		#()		-> Scalar
		#(7)		-> Unidimensional array of 7 elements
		#(7 4)		-> 7x4 elements matrix
		#(2 5 9)	-> 2x5x9 elements cube
		etc.
	"

	| bytesize |

	bytesize := aTensorShape totalAmountOfElements * aDataType dataSize.
	^ self
		newTyped: aDataType
		shaped: aTensorShape
		bytesize: bytesize
		thenDo: aBlock
]

{ #category : #'instance creation' }
TFTensor class >> pi [
	^ Float pi asTensor
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

	^ self allElements collect: #content
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
	^ self library tensorDataOf: self
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

	^ self type dataSize
]

{ #category : #iterating }
TFTensor >> elementsDo: oneArgBlock [

	| data |

	data := self data getHandle.
	1 to: self size do: [ :i | oneArgBlock value: ( self type getElementAt: i in: data ) ]
]

{ #category : #finalization }
TFTensor >> finalize [
	self delete
]

{ #category : #accessing }
TFTensor >> getHandle [

"We need to refactor later"
^ super getHandle getHandle
]

{ #category : #testing }
TFTensor >> isScalar [
	^self rank = 0
]

{ #category : #converting }
TFTensor >> library [
	^ TensorFlowCAPI current
]

{ #category : #accessing }
TFTensor >> numBytes [
	
	 ^ self byteSize
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
