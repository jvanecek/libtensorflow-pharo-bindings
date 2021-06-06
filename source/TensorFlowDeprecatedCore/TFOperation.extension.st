Extension { #name : #TFOperation }

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> * aTFOperation [
	^ self binaryOp: 'MatMul' with: aTFOperation
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> ** aTF_Operation [
	^ self binaryOp: 'Pow' with: aTF_Operation
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> *\ aTFOperation [
	^ self
		binaryOp: 'MatMul'
		with: aTFOperation
		described: [ :description | description at: 'transpose_b' putBoolean: true ]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> + aTFOperation [
	^ self binaryOp: 'Add' with: aTFOperation
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> += aTF_Operation [
	"Update self by adding a value"

	^ self binaryOp: 'AssignAdd' with: aTF_Operation
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> - aTFOperation [
	^ self binaryOp: 'Sub' with: aTFOperation
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> -= aTFOperation [
	^ self binaryOp: 'AssignSub' with: aTFOperation
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> > aTFOperation [
	^ self binaryOp: 'Greater' with: aTFOperation
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> @* aTFOperation [
	^ self binaryOp: 'Mul' with: aTFOperation
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> @/ aTFOperation [
	^ self binaryOp: 'Div' with: aTFOperation
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> \* aTFOperation [
	^ self
		binaryOp: 'MatMul'
		with: aTFOperation
		described: [ :description | description at: 'transpose_a' putBoolean: true ]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> \*\ aTF_Operation [
	^ self
		binaryOp: 'MatMul'
		with: aTF_Operation
		described: [ :description | 
			description at: 'transpose_a' putBoolean: true.
			description at: 'transpose_b' putBoolean: true ]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> \\ aTFOperation [
	^ self binaryOp: 'Mod' with: aTFOperation
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> abs [
	"Computes the absolute value of a tensor"
	"https://www.tensorflow.org/api_docs/cc/class/tensorflow/ops/abs"

	^ self unaryOp: 'Abs'
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> alias: nameString [
	"Return a tensor with the same shape and contents as the input tensor or value"
	"https://www.tensorflow.org/api_docs/cc/class/tensorflow/ops/identity"

	^ self unaryOp: 'Identity' named: nameString
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> arcCos [
	^ self unaryOp: 'Acos'
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> arcSin [
	^ self unaryOp: 'Asin'
	
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> arcTan [
	^ self unaryOp: 'Atan'
	
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> assign: aTF_Operation [
	^ self
		binaryOp: 'Assign'
		with: aTF_Operation
		named: (self nameFor: self name, '_initializer') 
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> binaryOp: aString with: aTF_Operation [
	^ self binaryOp: aString with: aTF_Operation described: [ :nothing |  ]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> binaryOp: aString with: aTF_Operation described: oneArgBlock [
	| name |
	name := self nameFor: aString.
	^ self
		binaryOp: aString
		with: aTF_Operation
		named: name
		described: oneArgBlock
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> binaryOp: aString with: aTF_Operation named: name [
	^ self binaryOp: aString with: aTF_Operation named: name described: [:nothing]

]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> binaryOp: aString with: aTF_Operation named: name described: oneArgBlock [
	^ self op: aString withAll: {aTF_Operation} named: name described: oneArgBlock
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> castTo: typeInteger [
	^ self unaryOp: 'Cast' described: [ :description | description at: 'DstT' putType: typeInteger ]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> cos [
	^ self unaryOp: 'Cos'
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> descent: delta rate: learningRate [
	^ self
		op: 'ApplyGradientDescent'
		withAll:
			{learningRate.
			delta}
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> exp [
	^ self unaryOp: 'Exp'
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> findMaxOn: aTF_Operation [
	^ self binaryOp: 'ArgMax' with: aTF_Operation
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> findMinOn: aTF_Operation [
	^ self binaryOp: 'ArgMin' with: aTF_Operation
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> identity [
	"Return a tensor with the same shape and contents as the input tensor or value"
	"https://www.tensorflow.org/api_docs/cc/class/tensorflow/ops/identity"

	^ self unaryOp: 'Identity'
	
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> inverse [
	"Return a tensor that is the inverse of the input"

	^ self unaryOp: 'MatrixInverse'
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> log [
	"CComputes natural logarithm of x element-wise"

	^ self unaryOp: 'Log'
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> meanOn: shapeTensorOrOperation [
	^ self binaryOp: 'Mean' with: shapeTensorOrOperation
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> nameFor: namePrefix [
	^ graph nameFor: namePrefix
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> negated [
	^ self unaryOp: 'Neg'
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> op: aString withAll: aTF_OperationArray [
	^ self op: aString withAll: aTF_OperationArray described: [:nothing]

]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> op: aString withAll: aTF_OperationArray described: oneArgBlock [
	| name |
	name := self nameFor: aString.
	^ self op: aString withAll: aTF_OperationArray named: name described: oneArgBlock
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> op: aString withAll: aTF_OperationArray named: name [
	^ self op: aString withAll: aTF_OperationArray named: name described: [:nothing]

]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> op: aString withAll: aTFOperationArray named: name described: oneArgBlock [

	^ graph
		newOperation: aString
		named: name
		described: [ :description | 
			description addInput: self firstOutput.
			aTFOperationArray
				do: [ :each | 
					| input |
					input := ( each asOperationOn: graph ) value firstOutput.
					description addInput: input
					].
			oneArgBlock value: description
			]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> rectified [
	"Computes rectified linear: f(x) = max(x, 0)"
	"https://en.wikipedia.org/wiki/Rectifier_(neural_networks)"

	^ self unaryOp: 'Relu'
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> rectified6 [
	"Computes rectified linear 6: f(x) = min(max(x, 0), 6)"

	^ self unaryOp: 'Relu6'
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> shape [
	^ self unaryOp: 'Shape'
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> sigmoid [
	^ self unaryOp: 'Sigmoid'
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> sin [
	^ self unaryOp: 'Sin'
	
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> sizeOn: dimensionInteger [
	^ self shape sliceFrom: {dimensionInteger} asInt32Tensor size: #(1) asInt32Tensor.
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> sliceFrom: begin size: size [
	^ self op: 'Slice' withAll: {begin. size}
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> softmax [
	^ self unaryOp: 'Softmax'

]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> sparseSoftmaxCrossEntropyWithLogits: aTF_Operation [
	^ self
		binaryOp: 'SparseSoftmaxCrossEntropyWithLogits'
		with: aTF_Operation
		named: (self nameFor: 'SparseSoftmaxCrossEntropyWithLogits')
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> squared [
	^ self @* self
	
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> sumOn: aTF_Operation [
	^ self binaryOp: 'Sum' with: aTF_Operation
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> tan [
	^ self unaryOp: 'Tan'
	
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> timesRectifiedGradOf: aTF_Operation [
	^ self binaryOp: 'ReluGrad' with: aTF_Operation
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> transposePermutingAxes: permutation [

	| name |
	name := 'Transpose'.
	^ self op: name withAll: { permutation } named: (self nameFor:name) described: [:description| ]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> unaryOp: aString [
	| name |
	name := self nameFor: aString.
	^ self unaryOp: aString named: name
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> unaryOp: aString described: oneArgBlock [
	| name |
	name := self nameFor: aString.
	^ self unaryOp: aString named: name described: oneArgBlock
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> unaryOp: aString named: name [
	^ self unaryOp: aString named: name described: [:description | ].
	
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFOperation >> unaryOp: aString named: name described: oneArgBlock [
	^ self op: aString withAll: {} named: name described: oneArgBlock
]
