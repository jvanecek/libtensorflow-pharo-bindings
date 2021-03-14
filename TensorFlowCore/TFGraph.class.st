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
	^ TensorFlowCAPI current newGraph initialize autoRelease
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

{ #category : #operations }
TFGraph >> add: nameString described: aBlock [
	^ self newOperation: 'Add' named: nameString described: aBlock
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

{ #category : #gtInspector }
TFGraph >> asRoassalView [
	^ self drawOnRoassalView: RTView new
]

{ #category : #operations }
TFGraph >> asString: nameString described: aBlock [
	^ self newOperation: 'AsString' named: nameString described: aBlock
]

{ #category : #operations }
TFGraph >> concat: nameString described: aBlock [
	^ self newOperation: 'Concat' named: nameString described: aBlock
]

{ #category : #'root operations' }
TFGraph >> const: aTFTensor [
	| name |
	name := self nameFor: 'constant'.
	^ self const: name value: aTFTensor
]

{ #category : #'root operations' }
TFGraph >> const: nameString value: aTFTensor [
	^ self
		newOperation: 'Const'
		named: nameString
		described: [ :description | 
			description at: 'dtype' putType: aTFTensor type.
			description at: 'value' putTensor: aTFTensor ]
]

{ #category : #accessing }
TFGraph >> definition [
"Return the protobuff serialisation of the graph"
	| buffer status |
	status := TFStatus create.
	buffer := TFBuffer new.
	self library graph: self toGraphDef: buffer status: status.
	status check.
	^ buffer dataBytes asString
]

{ #category : #gtInspector }
TFGraph >> drawOnRoassalView: view [
	| operations lab nodes edges |
	
	operations := self allOperations.
	lab := RTLabel new.
	nodes := (RTEllipse new
				size: 15;
				color: (Color blue alpha: 0.4)) + (lab text: [ :op | op name ]) elementsOn: operations.
	nodes @ RTDraggable.
	view @ RTDraggableView @RTZoomableView.
	
	view addAll:nodes.

	edges := OrderedCollection new.
	operations
				do: [ :op | 
					| nbInputs output op1 op2 |
					nbInputs := op inputsCount.
					0 to: nbInputs - 1 do: [ :index | 
						output := TensorFlowCAPI uniqueInstance operationInput: (op input: index).
						op1 := TFOperation fromHandle: output operation.
						op2 := (operations select: [ :opx | opx name = op1 name ]) at: 1.
						edges add: op2 -> op ] ].
	RTEdgeBuilder new
				view: view;
				shape:
					(RTArrowedLine new
						color: Color black);
				source: edges connectFrom: #key to: #value.
	(RTLayoutBuilder new forceWithCharge: -600) on: view elements.

	^ view
]

{ #category : #'initialize-release' }
TFGraph >> fromBlock: aBlockClosure [
	"Create operations from a block"

	| types |
	types := Array new: aBlockClosure argumentCount.
	types atAllPut: TFTensor typeFloat.
	^ self fromBlock: aBlockClosure inputTypes: types
]

{ #category : #'initialize-release' }
TFGraph >> fromBlock: aBlockClosure inputTypes: anArray [
	| inputs index |
	index := 0.
	inputs := (1 to: aBlockClosure argumentCount) collect: [:each |
		index := index + 1.
		self inputType: (anArray at: index)].
	^ aBlockClosure valueWithArguments: inputs.

]

{ #category : #'initialize-release' }
TFGraph >> fromBlock: aBlockClosure inputTypes: anArray named: nameString [

	| answer |

	self
		inScopeNamed: nameString
		do: [answer := self fromBlock: aBlockClosure inputTypes: anArray].
	^answer
]

{ #category : #'initialize-release' }
TFGraph >> fromBlock: aBlockClosure named: nameString [
	| types |
	types := Array new: aBlockClosure argumentCount.
	types atAllPut: TFTensor typeFloat.
	^ self fromBlock: aBlockClosure inputTypes: types named: nameString
]

{ #category : #gradients }
TFGraph >> gradientsOf: yArrayOfTFOutput withRespectTo: xArrayOfTFOutput product: dxArrayOfOutput [

	| y x dx status dy |

	y := TFOutputArray externalFromArray: yArrayOfTFOutput.
	x := TFOutputArray externalFromArray: xArrayOfTFOutput.
	dx := dxArrayOfOutput
		ifNil: [ ExternalData fromHandle: ExternalAddress new beNull type: ExternalType char asPointerType ]
		ifNotNil: [ TFOutputArray externalFromArray: dxArrayOfOutput ].
	dy := TFOutputArray externalNew: xArrayOfTFOutput size.
	status := TFStatus create.
	self library
		graph: self
		y: y
		yCount: yArrayOfTFOutput size
		x: x
		xCount: xArrayOfTFOutput size
		dx: dx
		status: status
		into: dy.
	status check.
	^ dy
]

{ #category : #gtInspector }
TFGraph >> gtInspectorGraphIn: composite [
	<gtInspectorPresentationOrder: 30>
	composite roassal2
		title: 'DataFlow';
		painting: [ :view | 
			self drawOnRoassalView: view.
			view ]
]

{ #category : #'initialize-release' }
TFGraph >> import: aTFBuffer [
	| options status |
	status := TFStatus create.
	options := TFImportGraphDefOptions create.
	self library
		importGraphDefInto: self
		from: aTFBuffer
		options: options
		status: status.
	options delete.
	status check
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

{ #category : #'root operations' }
TFGraph >> inputType: typeInteger [
	^ self
		newOperation: 'Placeholder'
		named: (self nameFor: 'input')
		described: [ :description | description at: 'dtype' putType: typeInteger ]
]

{ #category : #private }
TFGraph >> library [
	^ TensorFlowCAPI current
]

{ #category : #operations }
TFGraph >> mul: nameString described: aBlock [
	^ self newOperation: 'Mul' named: nameString described: aBlock
]

{ #category : #'random operations' }
TFGraph >> multinomialShaped: shapeConstant numSamples: aNumber [
	"Draws samples from a multinomial distribution."
	| numSamples|
	numSamples := self const: aNumber asInt32Tensor .

	^ shapeConstant op: 'Multinomial' withAll: {numSamples} named: 'Mltn' described:
	[:description |]
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
TFGraph >> newOperation: typeString named: aString [
	^ self
		newOperation: typeString
		named: aString
		described: [ :unused |  ]
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
	[operation := self operationAt: iterator.
		operation isNull] whileFalse: [oneArgBlock value: operation].

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
TFGraph >> outputDimensionsCount: aTF_Output [
	| status answer |
	status := TFStatus create.
	answer := self library forGraph: self outputDims: aTF_Output status: status.
	status check.
	^ answer
]

{ #category : #'random operations' }
TFGraph >> parametrizedTruncatedNormalShaped: shapeArray means: means stdevs: stdevs minVals:minVals maxVals:maxVals [
	| shape meansTensor stdevsTensor minValsTensor maxValsTensor |
	shape := self const: shapeArray asInt32Tensor.
	meansTensor := self const: means asFloatTensor.
	stdevsTensor := self const: stdevs asFloatTensor.
	minValsTensor := self const: minVals asFloatTensor.
	maxValsTensor := self const: maxVals asFloatTensor.	
	^ shape op: 'ParameterizedTruncatedNormal' withAll: {meansTensor. stdevsTensor. minValsTensor.maxValsTensor} named: 'Mltn' described:
	[:description |]
]

{ #category : #'random operations' }
TFGraph >> parametrizedTruncatedNormalShaped: shapeArray stddev: aNumber [
	| random |
	random := self truncatedNormalRandomShaped: shapeArray.
	^ random @* (self const: aNumber asTensor)
]

{ #category : #'root operations' }
TFGraph >> placeholder: nameString type: typeInteger [
	^ self
		newOperation: 'Placeholder'
		named: nameString
		described: [ :description | description at: 'dtype' putType: typeInteger ]
]

{ #category : #'random operations' }
TFGraph >> randomGamma:shapeArray alpha: alpha [ 
	"Outputs random values from a uniform distribution."
	| shape alphaTensor |
	shape := self const: shapeArray asInt32Tensor.
	alphaTensor:= self const: alpha asFloatTensor.

	^ shape op: 'RandomGamma' withAll: {alphaTensor.} named: 'RG' described:
	[:description |]
]

{ #category : #'random operations' }
TFGraph >> randomNormalShaped:shapeArray [
	"Outputs random values from a normal distribution"
	| shape |
	shape := self const: shapeArray asInt32Tensor.
	^ shape unaryOp: 'RandomStandardNormal' described: [:description |
		description at: 'dtype' putType: TFTensor typeFloat]
]

{ #category : #'random operations' }
TFGraph >> randomNormalShaped: shapeArray stddev: aNumber [
	| random |
	random := self randomNormalShaped: shapeArray.
	^ random @* (self const: aNumber asTensor)
]

{ #category : #'random operations' }
TFGraph >> randomPoisson:shapeArray rate: rate [ 
	"Outputs random values from a uniform distribution."
	| shape  rateTensor |
	shape := self const: shapeArray asInt32Tensor.
	rateTensor:= self const: rate asFloatTensor.

	^ shape op: 'RandomPoissonV2' withAll: {rateTensor.} named: 'RP' described:
	[:description |]
]

{ #category : #'random operations' }
TFGraph >> randomShuffle: aTensor [
	
	| shape |
	shape := self const: aTensor.
	^ shape unaryOp: 'RandomShuffle' described: [:description |]
]

{ #category : #'random operations' }
TFGraph >> randomUniformIntShaped:shapeArray minVal: minTensorAsArray maxVal:maxTensorAsArray [
	"Outputs random values from a uniform distribution."
	| shape mini maxi |
	shape := self const: shapeArray asInt32Tensor.
	mini:= self const: minTensorAsArray asInt32Tensor.
	maxi := self const: maxTensorAsArray  asInt32Tensor.
	^ shape op: 'RandomUniformInt' withAll: {mini. maxi.} named: 'RUI' described:
	[:description |]
]

{ #category : #'random operations' }
TFGraph >> randomUniformShaped:shapeArray [
	"Outputs random values from a uniform distribution."
	| shape |
	shape := self const: shapeArray asInt32Tensor.
	^ shape unaryOp: 'RandomUniform' described: [:description |
		description at: 'dtype' putType: TFTensor typeFloat]
]

{ #category : #'random operations' }
TFGraph >> randomUniformShaped: shapeArray stddev: aNumber [
	| random |
	random := self randomUniformIntShaped: shapeArray.
	^ random @* (self const: aNumber asTensor)
]

{ #category : #outputs }
TFGraph >> rankOf: aTFOutputOrInput [
	| status answer |
	status := TFStatus create.
	answer := self library
		graph: self
		getRankOf: aTFOutputOrInput
		status: status.
	status check.
	^ answer
]

{ #category : #running }
TFGraph >> runInputs: inArrayOfTFOutputs values: inArrayOfTFTensor outputs: outArrayOfTFOutputs [
	| session |
	session := TFSession on: self.
	self initializeOn: session.
	^ session
		runInputs: inArrayOfTFOutputs
		values: inArrayOfTFTensor
		outputs: outArrayOfTFOutputs
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
	| status value size answer |
	size := self rankOf: aTFOutputOrInput.
	value := FFIExternalArray externalNewType: 'int64' size: size.
	status := TFStatus create.
	self library
		graph: self
		getShapeOf: aTFOutputOrInput
		into: value getHandle
		size: size
		status: status.
	status check.
	answer := (1 to: size) collect: [ :i | value at: i ].
	^ answer asTensorShape
]

{ #category : #outputs }
TFGraph >> shapeOf: aTFOutputOrInput set: shape [
	| status value |
	value := FFIExternalArray externalNewType: 'int64' fromArray: shape.
	status := TFStatus create.
	self library
		graph: self
		setShapeOf: aTFOutputOrInput
		to: value getHandle
		size: shape size
		status: status.
	status check
]

{ #category : #'root operations' }
TFGraph >> truncatedNormalRandomShaped: shapeArray [
	| shape |
	shape := self const: shapeArray asInt32Tensor.
	^ shape
		unaryOp: 'TruncatedNormal'
		described: [ :description | description at: 'dtype' putType: TFTensor typeFloat ]
]

{ #category : #'root operations' }
TFGraph >> truncatedNormalRandomShaped: shapeArray stddev: aNumber [
	| random |
	random := self truncatedNormalRandomShaped: shapeArray.
	^ random @* (self const: aNumber asTensor)
]

{ #category : #'root operations' }
TFGraph >> variable: nameString forTensor: aTFTensor [
	^ self
		variable: nameString
		type: aTFTensor type
		shape: aTFTensor shape
]

{ #category : #'root operations' }
TFGraph >> variable: nameString initialValue: aTFTensor [
	| const var |
	var := self variable: nameString forTensor: aTFTensor.
	const := self const: nameString , '_initialValue' value: aTFTensor.
	var assign: const.
	^ var
]

{ #category : #'root operations' }
TFGraph >> variable: nameString initialValueFrom: aTFOperation [
	| output var shape |
	output := aTFOperation output: 0.
	shape := self shapeOf: output.
	var := self variable: nameString type: output type shape: shape.
	var assign: aTFOperation.
	^ var
]

{ #category : #'root operations' }
TFGraph >> variable: nameString type: typeInteger shape: anArray [
	^ self
		newOperation: 'Variable'
		named: nameString
		described: [ :description | 
			description
				at: 'dtype' putType: typeInteger;
				at: 'shape' putShape: anArray asTensorShape ]
]

{ #category : #debugging }
TFGraph >> writeDefTo: strm [
	strm nextPutAll: self definition
]

{ #category : #debugging }
TFGraph >> writeDefToFileNamed: filename [
	filename asFileReference writeStreamDo: [ :strm | self writeDefTo: strm ]
]

{ #category : #'root operations' }
TFGraph >> zerosShaped: shapeArray [
	"This operation creates a tensor of shape shapeArray and fills it zero"
	
	| shape |
	shape := self const: shapeArray asInt32Tensor.
	^ shape binaryOp: 'Fill' with: 0.0 asTensor
]
