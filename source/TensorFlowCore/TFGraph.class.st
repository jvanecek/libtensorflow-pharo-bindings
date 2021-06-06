"
A TensorFlow computation, represented as a dataflow graph.

A Graph contains a set of Operation objects, which represent units of computation; and Tensor objects, which represent the units of data that flow between operations.
"
Class {
	#name : #TFGraph,
	#superclass : #FFIOpaqueObject,
	#instVars : [
		'context'
	],
	#category : #TensorFlowCore
}

{ #category : #'instance creation' }
TFGraph class >> create [

	^ TensorFlowCAPI current newGraph
]

{ #category : #'instance creation' }
TFGraph class >> finalizeResourceData: handle [
	handle isNull ifTrue: [ ^ self ].
	(TensorFlowCAPI current) deleteGraph: handle
	
]

{ #category : #'instance creation' }
TFGraph class >> fromBinaryFileNamed: aString [
	^ self create importBinaryFileNamed: aString
]

{ #category : #'instance creation' }
TFGraph class >> fromBlock: aBlockClosure [
	| output graph |
	graph := self create.
	output := graph fromBlock: aBlockClosure.
	output alias: 'output'.
	^ graph
]

{ #category : #'instance creation' }
TFGraph class >> fromFileNamed: aString [
	^ self create importFileNamed: aString
]

{ #category : #'instance creation' }
TFGraph class >> fromString: aString [
	^ self create importString: aString
]

{ #category : #accessing }
TFGraph >> allInitializers [
	^ self
		operationsSelect: [ :op | op type = 'Assign' and: [ op name endsWith: '_initializer' ] ]
]

{ #category : #accessing }
TFGraph >> allInputs [
	^ self operationsSelect: [ :op | op type = 'Placeholder' ]
]

{ #category : #accessing }
TFGraph >> allOperations [
	^ self operationsSelect: [ :op | true ]
]

{ #category : #accessing }
TFGraph >> allVariables [
	^ self operationsSelect: [ :op | op type = 'Variable' ]
]

{ #category : #accessing }
TFGraph >> definition [
	
	^ self library graphDefinitionOf: self 
]

{ #category : #'initialize-release' }
TFGraph >> import: aTFBuffer [

	self library importGraphDefFrom: aTFBuffer into: self
]

{ #category : #'initialize-release' }
TFGraph >> importBinaryFileNamed: aString [
	| buffer |
	buffer := TFBuffer fromBinaryFileNamed: aString.
	[self import: buffer] ensure: [buffer delete].
]

{ #category : #'initialize-release' }
TFGraph >> importFileNamed: aString [
	| buffer |
	buffer := TFBuffer fromFileNamed: aString.
	[ self import: buffer ]
		ensure: [ buffer delete ]
]

{ #category : #'initialize-release' }
TFGraph >> importString: aString [
	| buffer |
	buffer := TFBuffer fromString: aString.
	[self import: buffer] ensure: ["buffer delete"].
]

{ #category : #'initialize-release' }
TFGraph >> inScopeNamed: aName do: aBlock [

	| previousContext |

	previousContext := context.
	context := context , aName , '/'.
	^aBlock ensure: [context := previousContext]
]

{ #category : #initialization }
TFGraph >> initialize [
	context := ''
]

{ #category : #running }
TFGraph >> initializeOn: aTFSession [
	| initializers |
	initializers := self allInitializers
		collect: [ :each | each output: 0 ].
	initializers size > 0
		ifTrue: [ aTFSession runOutputs: initializers ]
]

{ #category : #private }
TFGraph >> library [
	^ TensorFlowCAPI current
]

{ #category : #'root operations' }
TFGraph >> nameFor: aNodeName [

	| preffix count |

	preffix := context , aNodeName.
	count := (self operationsSelect: [:op | op name beginsWithSubCollection: preffix]) size.
	count strictlyPositive ifTrue: [preffix := preffix , '_' , count printString].
	^preffix
]

{ #category : #operations }
TFGraph >> newOperation: typeString named: aString described: aBlock [
	| description answer |
	description := self
		newOperationDescription: typeString
		named: aString.
	aBlock value: description.
	answer := description finish.
	answer graph: self.
	^ answer
]

{ #category : #operations }
TFGraph >> newOperationDescription: typeString named: aString [
	^ self library
		newOperationDescriptionOn: self
		type: typeString
		named: aString
]

{ #category : #accessing }
TFGraph >> newOperationIteratorContext [
	^ ByteArray new: 8
]

{ #category : #accessing }
TFGraph >> operationAt: contextULongLongPtr [
	^ self library graph: self operationAt: contextULongLongPtr
]

{ #category : #accessing }
TFGraph >> operationNamed: aString [
	| answer |
	answer := self library graph: self getOperationNamed: aString asAsciiZ.
	answer isNull ifTrue: [self error: 'Operation not found'].
	^ answer

]

{ #category : #accessing }
TFGraph >> operationNamed: aString ifFound: aFoundBlock ifNotFound: aNotFoundBlock [

	| answer |

	answer := self library graph: self getOperationNamed: aString asAsciiZ.
	^answer isNull ifTrue: aNotFoundBlock ifFalse: [aFoundBlock cull: answer]
]

{ #category : #accessing }
TFGraph >> operationsCount [
	| answer |
	answer := 0.
	self operationsDo: [ :each | answer := answer + 1 ].
	^ answer
]

{ #category : #accessing }
TFGraph >> operationsDo: oneArgBlock [
	| iterator operation |
	iterator := self newOperationIteratorContext.
	[ operation := self operationAt: iterator.
	operation isNull ] whileFalse: [ oneArgBlock value: operation ]
]

{ #category : #accessing }
TFGraph >> operationsSelect: oneArgBlock [
	| answer |
	answer := OrderedCollection new.
	self operationsSelect: oneArgBlock thenDo: [ :op | answer add: op ].
	^ answer asArray
]

{ #category : #accessing }
TFGraph >> operationsSelect: conditionBlock thenDo: actionBlock [
	| answer |
	answer := OrderedCollection new.
	self
		operationsDo: [ :op | 
			(conditionBlock value: op)
				ifTrue: [ actionBlock value: op ] ].
	^ answer asArray
]

{ #category : #outputs }
TFGraph >> outputDimensionsCount: aTFOutput [

	^  self library forGraph: self outputDims: aTFOutput
]

{ #category : #outputs }
TFGraph >> rankOf: aTFOutputOrInput [

	^ self library graph: self getRankOf: aTFOutputOrInput
]

{ #category : #running }
TFGraph >> runOutput: aTFOutput [
	| session |
	session := TFSession on: self.
	self initializeOn: session.
	^ session runOutput: aTFOutput
]

{ #category : #running }
TFGraph >> runOutputs: anArrayOfTFOutputs [
	| session |
	session := TFSession on: self.
	self initializeOn: session.
	^ session runOutputs: anArrayOfTFOutputs
]

{ #category : #outputs }
TFGraph >> shapeOf: aTFOutputOrInput [

	^self library graph: self getShapeOf: aTFOutputOrInput
]

{ #category : #accessing }
TFGraph >> shapeOf: aTFOutputOrInput set: shape [

	self library graph: self setShapeOf: aTFOutputOrInput to: shape
]

{ #category : #debugging }
TFGraph >> writeDefTo: strm [
	strm nextPutAll: self definition
]

{ #category : #debugging }
TFGraph >> writeDefToFileNamed: filename [
	filename asFileReference writeStreamDo: [ :strm | self writeDefTo: strm ]
]
