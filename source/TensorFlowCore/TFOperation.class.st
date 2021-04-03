"
Operation that has been added to the graph. Valid until the graph is deleted -- in particular adding a new operation to the graph does not  invalidate old TF_Operation* pointers.
"
Class {
	#name : #TFOperation,
	#superclass : #FFIOpaqueObject,
	#instVars : [
		'graph',
		'output'
	],
	#category : #TensorFlowCore
}

{ #category : #comparing }
TFOperation >> = aTF_Operation [
	^ self class = aTF_Operation class and: [ 
		" Doing this so different instances of the same pointer matches "
		handle asString  = aTF_Operation getHandle asString ]
]

{ #category : #converting }
TFOperation >> asOperationOn: aTF_Graph [
	graph == aTF_Graph
		ifTrue: [^ self]
		ifFalse: [^ self error: 'Can''t move an operation to another Graph']
]

{ #category : #attributes }
TFOperation >> attrMetadata: nameString [
	| status answer |
	status := TFStatus create.
	answer := self library operation: self getMetadataFor: nameString asAsciiZ status: status.
	status check.
	^ answer
]

{ #category : #attributes }
TFOperation >> boolAt: nameString [
	| value status |
	status := TFStatus create.
	value := ByteArray new: 1.
	self library
		operation: self
		attr: nameString asAsciiZ
		getBool: value
		status: status.
	status check.
	^ value booleanAt: 1
]

{ #category : #accessing }
TFOperation >> device [
"The name of the device to which this op has been assigned, if any.
Returns: The string name of the device to which this op has been assigned, or an empty string if it has not been assigned to a device."
	^ self library operationDevice: self
]

{ #category : #accessing }
TFOperation >> firstInput [
	^ self input: 0
]

{ #category : #initialization }
TFOperation >> firstOutput [
	output ifNil: [ output := 0 ].
	^ self output: output
]

{ #category : #attributes }
TFOperation >> floatAt: nameString [
	| value status |
	status := TFStatus create.
	value := ByteArray new: 8.
	self library
		operation: self
		attr: nameString asAsciiZ
		getFloat: value
		status: status.
	status check.
	^ value floatAt: 1
]

{ #category : #accessing }
TFOperation >> graph [
	"The Graph that contains this operation"
	
	^ graph
]

{ #category : #accessing }
TFOperation >> graph: aTF_Graph [
	graph := aTF_Graph
]

{ #category : #accessing }
TFOperation >> input: anInteger [
	"Return input at position anInteger"
	
	^ TFInput onOperation: self index: anInteger
]

{ #category : #accessing }
TFOperation >> inputsCount [
	"Returns number of inputs of this operation"
	
	^ self library operationNumInputs: self
]

{ #category : #attributes }
TFOperation >> intAt: nameString [
	| value status |
	status := TFStatus create.
	value := ByteArray new: 8.
	self library operation: self attr: nameString asAsciiZ getInt64: value status: status.
	status check.
	^ value unsignedLongLongAt: 1

]

{ #category : #accessing }
TFOperation >> library [
	^ TensorFlowCAPI current
]

{ #category : #accessing }
TFOperation >> name [
	"The full name of this operation"
	
	^ self library operationName: self
]

{ #category : #initialization }
TFOperation >> output [
	"The list of Tensor objects representing the outputs of this op."

	output ifNil: [ output := 0 ].
	^ self output: output
]

{ #category : #accessing }
TFOperation >> output: anInteger [
	"Return output at position anInteger"
	
	^ TFOutput onOperation: self index: anInteger
]

{ #category : #accessing }
TFOperation >> outputsCount [
	"Returns number of inputs of this operation"
	
	^ self library operationNumOutputs: self
]

{ #category : #printing }
TFOperation >> printOn: stream [
	super printOn: stream.
	handle isNull
		ifFalse: [ stream
				space;
				print: self type;
				space;
				print: self name ]
]

{ #category : #attributes }
TFOperation >> shapeAt: nameString [
	| value status size answer |
	size := (self attrMetadata: nameString) total_size.
	(size = -1) ifTrue:[^#()].
	status := TFStatus create.
	value := FFIExternalArray externalNewType: 'int64' size: size.
	
	self library
		operation: self
		attr: nameString asAsciiZ
		getShape: value getHandle
		size: size
		status: status.
	status check.

	answer := (1 to: size) collect: [:i | value at: i].
	^ TensorShape withDimensionsSized: answer
]

{ #category : #attributes }
TFOperation >> stringAt: nameString [
	| metadata value status |
	metadata := self attrMetadata: nameString.
	status := TFStatus create.
	value := ByteArray new: metadata total_size.
	self library
		operation: self
		attr: nameString asAsciiZ
		getString: value
		size: metadata total_size 
		status: status.
	status check.
	^ value asString

]

{ #category : #attributes }
TFOperation >> stringsAt: nameString [
	| status pointers sizes spaceRequired storage metadata valuesCount |
	metadata := self attrMetadata: nameString.
	spaceRequired := metadata totalSize.
	valuesCount := metadata listSize.
	pointers := ByteArray new: Smalltalk wordSize * valuesCount.
	sizes := (FFIExternalArray externalNewType: 'int64' size: valuesCount) autoRelease.
	storage := ExternalAddress gcallocate: spaceRequired.
	status := TFStatus create.
	self library
		operation: self
		attr: nameString asAsciiZ 
		getStrings: pointers
		sizes: sizes getHandle
		maxCount: valuesCount
		storage: storage
		size: spaceRequired
		status: status.
	status check.
	^ (1 to: valuesCount) collect: [:i |
		| one |
		one := pointers pointerAt: i-1*Smalltalk wordSize+1.
		one := one structAt: 1 length: (sizes at: i).
		one asString]
]

{ #category : #attributes }
TFOperation >> tensorAt: nameString [
	| value status |
	status := TFStatus create.
	value := ByteArray new: ExternalAddress wordSize.
	self library operation: self attr: nameString asAsciiZ getTensor: value status: status.
	status check.
	^ TFTensor fromHandle: (value pointerAt: 1)

]

{ #category : #accessing }
TFOperation >> type [
	"The type of the op (e.g. MatMul)"

	^ self library operationOpType: self
]

{ #category : #attributes }
TFOperation >> typeAt: nameString [
	| value status |
	status := TFStatus create.
	value := ByteArray new: 8.
	self library operation: self attr: nameString asAsciiZ getType: value status: status.
	status check.
	^ value unsignedLongLongAt: 1

]

{ #category : #accessing }
TFOperation >> useOutput: anInteger [
	output := anInteger
]
