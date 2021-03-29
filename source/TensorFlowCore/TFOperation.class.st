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

{ #category : #'ops binary' }
TFOperation >> * aTFOperation [
	^ self binaryOp: 'MatMul' with: aTFOperation
]

{ #category : #'ops binary' }
TFOperation >> ** aTF_Operation [
	^ self binaryOp: 'Pow' with: aTF_Operation
]

{ #category : #'ops binary' }
TFOperation >> *\ aTFOperation [
	^ self
		binaryOp: 'MatMul'
		with: aTFOperation
		described: [ :description | description at: 'transpose_b' putBoolean: true ]
]

{ #category : #'ops binary' }
TFOperation >> + aTFOperation [
	^ self binaryOp: 'Add' with: aTFOperation
]

{ #category : #'ops binary' }
TFOperation >> += aTF_Operation [
	"Update self by adding a value"

	^ self binaryOp: 'AssignAdd' with: aTF_Operation
]

{ #category : #'ops binary' }
TFOperation >> - aTFOperation [
	^ self binaryOp: 'Sub' with: aTFOperation
]

{ #category : #'ops binary' }
TFOperation >> -= aTFOperation [
	^ self binaryOp: 'AssignSub' with: aTFOperation
]

{ #category : #comparing }
TFOperation >> = aTF_Operation [
	^ self class = aTF_Operation class and: [ 
		" Doing this so different instances of the same pointer matches "
		handle asString  = aTF_Operation getHandle asString ]
]

{ #category : #'ops binary' }
TFOperation >> > aTFOperation [
	^ self binaryOp: 'Greater' with: aTFOperation
]

{ #category : #'ops binary' }
TFOperation >> @* aTFOperation [
	^ self binaryOp: 'Mul' with: aTFOperation
]

{ #category : #'ops binary' }
TFOperation >> @/ aTFOperation [
	^ self binaryOp: 'Div' with: aTFOperation
]

{ #category : #'ops binary' }
TFOperation >> \* aTFOperation [
	^ self
		binaryOp: 'MatMul'
		with: aTFOperation
		described: [ :description | description at: 'transpose_a' putBoolean: true ]
]

{ #category : #'ops binary' }
TFOperation >> \*\ aTF_Operation [
	^ self
		binaryOp: 'MatMul'
		with: aTF_Operation
		described: [ :description | 
			description at: 'transpose_a' putBoolean: true.
			description at: 'transpose_b' putBoolean: true ]
]

{ #category : #'ops binary' }
TFOperation >> \\ aTFOperation [
	^ self binaryOp: 'Mod' with: aTFOperation
]

{ #category : #'ops unary' }
TFOperation >> abs [
	"Computes the absolute value of a tensor"
	"https://www.tensorflow.org/api_docs/cc/class/tensorflow/ops/abs"

	^ self unaryOp: 'Abs'
]

{ #category : #'ops unary' }
TFOperation >> alias: nameString [
	"Return a tensor with the same shape and contents as the input tensor or value"
	"https://www.tensorflow.org/api_docs/cc/class/tensorflow/ops/identity"

	^ self unaryOp: 'Identity' named: nameString
]

{ #category : #'ops unary' }
TFOperation >> arcCos [
	^ self unaryOp: 'Acos'
]

{ #category : #'ops unary' }
TFOperation >> arcSin [
	^ self unaryOp: 'Asin'
	
]

{ #category : #'ops unary' }
TFOperation >> arcTan [
	^ self unaryOp: 'Atan'
	
]

{ #category : #converting }
TFOperation >> asOperationOn: aTF_Graph [
	graph == aTF_Graph
		ifTrue: [^ self]
		ifFalse: [^ self error: 'Can''t move an operation to another Graph']
]

{ #category : #'ops binary' }
TFOperation >> assign: aTF_Operation [
	^ self
		binaryOp: 'Assign'
		with: aTF_Operation
		named: (self nameFor: self name, '_initializer') 
]

{ #category : #attributes }
TFOperation >> attrMetadata: nameString [
	| status answer |
	status := TFStatus create.
	answer := self library operation: self getMetadataFor: nameString asAsciiZ status: status.
	status check.
	^ answer
]

{ #category : #'ops binary' }
TFOperation >> binaryOp: aString with: aTF_Operation [
	^ self binaryOp: aString with: aTF_Operation described: [ :nothing |  ]
]

{ #category : #'ops binary' }
TFOperation >> binaryOp: aString with: aTF_Operation described: oneArgBlock [
	| name |
	name := self nameFor: aString.
	^ self
		binaryOp: aString
		with: aTF_Operation
		named: name
		described: oneArgBlock
]

{ #category : #'ops binary' }
TFOperation >> binaryOp: aString with: aTF_Operation named: name [
	^ self binaryOp: aString with: aTF_Operation named: name described: [:nothing]

]

{ #category : #'ops binary' }
TFOperation >> binaryOp: aString with: aTF_Operation named: name described: oneArgBlock [
	^ self op: aString withAll: {aTF_Operation} named: name described: oneArgBlock
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

{ #category : #'ops binary' }
TFOperation >> castTo: typeInteger [
	^ self unaryOp: 'Cast' described: [ :description | description at: 'DstT' putType: typeInteger ]
]

{ #category : #'ops unary' }
TFOperation >> cos [
	^ self unaryOp: 'Cos'
]

{ #category : #'ops other' }
TFOperation >> descent: delta rate: learningRate [
	^ self
		op: 'ApplyGradientDescent'
		withAll:
			{learningRate.
			delta}
]

{ #category : #accessing }
TFOperation >> device [
"The name of the device to which this op has been assigned, if any.
Returns: The string name of the device to which this op has been assigned, or an empty string if it has not been assigned to a device."
	^ self library operationDevice: self
]

{ #category : #'ops unary' }
TFOperation >> exp [
	^ self unaryOp: 'Exp'
]

{ #category : #'ops binary' }
TFOperation >> findMaxOn: aTF_Operation [
	^ self binaryOp: 'ArgMax' with: aTF_Operation
]

{ #category : #'ops binary' }
TFOperation >> findMinOn: aTF_Operation [
	^ self binaryOp: 'ArgMin' with: aTF_Operation
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

{ #category : #'ops unary' }
TFOperation >> identity [
	"Return a tensor with the same shape and contents as the input tensor or value"
	"https://www.tensorflow.org/api_docs/cc/class/tensorflow/ops/identity"

	^ self unaryOp: 'Identity'
	
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

{ #category : #'ops unary' }
TFOperation >> inverse [
	"Return a tensor that is the inverse of the input"

	^ self unaryOp: 'MatrixInverse'
]

{ #category : #'ops binary' }
TFOperation >> library [
	^ TensorFlowCAPI current
]

{ #category : #accessing }
TFOperation >> log [
	"CComputes natural logarithm of x element-wise"

	^ self unaryOp: 'Log'
]

{ #category : #'ops binary' }
TFOperation >> meanOn: shapeTensorOrOperation [
	^ self binaryOp: 'Mean' with: shapeTensorOrOperation
]

{ #category : #accessing }
TFOperation >> name [
	"The full name of this operation"
	
	^ self library operationName: self
]

{ #category : #'ops other' }
TFOperation >> nameFor: namePrefix [
	^ graph nameFor: namePrefix
]

{ #category : #'ops unary' }
TFOperation >> negated [
	^ self unaryOp: 'Neg'
]

{ #category : #'ops other' }
TFOperation >> op: aString withAll: aTF_OperationArray [
	^ self op: aString withAll: aTF_OperationArray described: [:nothing]

]

{ #category : #'ops other' }
TFOperation >> op: aString withAll: aTF_OperationArray described: oneArgBlock [
	| name |
	name := self nameFor: aString.
	^ self op: aString withAll: aTF_OperationArray named: name described: oneArgBlock
]

{ #category : #'ops other' }
TFOperation >> op: aString withAll: aTF_OperationArray named: name [
	^ self op: aString withAll: aTF_OperationArray named: name described: [:nothing]

]

{ #category : #'ops other' }
TFOperation >> op: aString withAll: aTF_OperationArray named: name described: oneArgBlock [
	^ graph newOperation: aString named: name described: [:description |
		description addInput: self output.
		aTF_OperationArray do: [:each |
			| input |
			input := (each asOperationOn: graph) output.
			description addInput: input].
		oneArgBlock value: description].
	
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

{ #category : #'ops unary' }
TFOperation >> rectified [
	"Computes rectified linear: f(x) = max(x, 0)"
	"https://en.wikipedia.org/wiki/Rectifier_(neural_networks)"

	^ self unaryOp: 'Relu'
]

{ #category : #'ops unary' }
TFOperation >> rectified6 [
	"Computes rectified linear 6: f(x) = min(max(x, 0), 6)"

	^ self unaryOp: 'Relu6'
]

{ #category : #'ops unary' }
TFOperation >> shape [
	^ self unaryOp: 'Shape'
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

{ #category : #'ops unary' }
TFOperation >> sigmoid [
	^ self unaryOp: 'Sigmoid'
]

{ #category : #'ops unary' }
TFOperation >> sin [
	^ self unaryOp: 'Sin'
	
]

{ #category : #'ops binary' }
TFOperation >> sizeOn: dimensionInteger [
	^ self shape sliceFrom: {dimensionInteger} asInt32Tensor size: #(1) asInt32Tensor.
]

{ #category : #'ops other' }
TFOperation >> sliceFrom: begin size: size [
	^ self op: 'Slice' withAll: {begin. size}
]

{ #category : #'ops unary' }
TFOperation >> softmax [
	^ self unaryOp: 'Softmax'

]

{ #category : #'ops binary' }
TFOperation >> sparseSoftmaxCrossEntropyWithLogits: aTF_Operation [
	^ self
		binaryOp: 'SparseSoftmaxCrossEntropyWithLogits'
		with: aTF_Operation
		named: (self nameFor: 'SparseSoftmaxCrossEntropyWithLogits')
]

{ #category : #'ops unary' }
TFOperation >> squared [
	^ self @* self
	
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

{ #category : #'ops binary' }
TFOperation >> sumOn: aTF_Operation [
	^ self binaryOp: 'Sum' with: aTF_Operation
]

{ #category : #'ops unary' }
TFOperation >> tan [
	^ self unaryOp: 'Tan'
	
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

{ #category : #'ops binary' }
TFOperation >> timesRectifiedGradOf: aTF_Operation [
	^ self binaryOp: 'ReluGrad' with: aTF_Operation
]

{ #category : #'ops unary' }
TFOperation >> transposePermutingAxes: permutation [

	| name |
	name := 'Transpose'.
	^ self op: name withAll: { permutation } named: (self nameFor:name) described: [:description| ]
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

{ #category : #'ops unary' }
TFOperation >> unaryOp: aString [
	| name |
	name := self nameFor: aString.
	^ self unaryOp: aString named: name
]

{ #category : #'ops unary' }
TFOperation >> unaryOp: aString described: oneArgBlock [
	| name |
	name := self nameFor: aString.
	^ self unaryOp: aString named: name described: oneArgBlock
]

{ #category : #'ops unary' }
TFOperation >> unaryOp: aString named: name [
	^ self unaryOp: aString named: name described: [:description | ].
	
]

{ #category : #'ops unary' }
TFOperation >> unaryOp: aString named: name described: oneArgBlock [
	^ self op: aString withAll: {} named: name described: oneArgBlock
]

{ #category : #accessing }
TFOperation >> useOutput: anInteger [
	output := anInteger
]
