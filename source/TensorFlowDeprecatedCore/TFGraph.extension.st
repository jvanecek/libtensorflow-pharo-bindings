Extension { #name : #TFGraph }

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> add: nameString described: aBlock [
	^ self newOperation: 'Add' named: nameString described: aBlock
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> asString: nameString described: aBlock [
	^ self newOperation: 'AsString' named: nameString described: aBlock
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> concat: nameString described: aBlock [
	^ self newOperation: 'Concat' named: nameString described: aBlock
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> const: aTFTensor [
	| name |
	name := self nameFor: 'constant'.
	^ self const: name value: aTFTensor
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> const: nameString value: aTFTensor [
	^ self
		newOperation: 'Const'
		named: nameString
		described: [ :description | 
			description at: 'dtype' putType: aTFTensor type.
			description at: 'value' putTensor: aTFTensor ]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> fromBlock: aBlockClosure [
	"Create operations from a block"

	| types |
	types := Array new: aBlockClosure argumentCount.
	types atAllPut: TFTensor typeFloat.
	^ self fromBlock: aBlockClosure inputTypes: types
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> fromBlock: aBlockClosure inputTypes: anArray [
	| inputs index |
	index := 0.
	inputs := (1 to: aBlockClosure argumentCount) collect: [:each |
		index := index + 1.
		self inputType: (anArray at: index)].
	^ aBlockClosure valueWithArguments: inputs.

]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> fromBlock: aBlockClosure inputTypes: anArray named: nameString [

	| answer |

	self
		inScopeNamed: nameString
		do: [answer := self fromBlock: aBlockClosure inputTypes: anArray].
	^answer
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> fromBlock: aBlockClosure named: nameString [
	| types |
	types := Array new: aBlockClosure argumentCount.
	types atAllPut: TFTensor typeFloat.
	^ self fromBlock: aBlockClosure inputTypes: types named: nameString
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> inputType: typeInteger [
	^ self
		newOperation: 'Placeholder'
		named: (self nameFor: 'input')
		described: [ :description | description at: 'dtype' putType: typeInteger ]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> mul: nameString described: aBlock [
	^ self newOperation: 'Mul' named: nameString described: aBlock
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> multinomialShaped: shapeConstant numSamples: aNumber [
	"Draws samples from a multinomial distribution."
	| numSamples|
	numSamples := self const: aNumber asInt32Tensor .

	^ shapeConstant op: 'Multinomial' withAll: {numSamples} named: 'Mltn' described:
	[:description |]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> newOperationOf: aString namePrefixed: anOperationPreffix with: anArgumentOne with: anArgumentTwo [

	^ self
		newOperationOf: aString
		namePrefixed: anOperationPreffix
		withAll: ( Array with: anArgumentOne with: anArgumentTwo )
		describedBy: [ :desc |  ]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> newOperationOf: aString namePrefixed: anOperationPreffix withAll: anInputCollection describedBy: aBlockClosure [

	^ self
		newOperation: aString
		named: ( self nameFor: anOperationPreffix )
		described: [ :description | 
			anInputCollection
				do: [ :each | 
					| input |

					input := ( each asOperationOn: self ) firstOutput.
					description addInput: input
					].
			aBlockClosure value: description
			]
]

{ #category : #'*TensorFlowDeprecatedCore' }
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

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> parametrizedTruncatedNormalShaped: shapeArray stddev: aNumber [
	| random |
	random := self truncatedNormalRandomShaped: shapeArray.
	^ random @* (self const: aNumber asTensor)
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> placeholder: nameString type: typeInteger [
	^ self
		newOperation: 'Placeholder'
		named: nameString
		described: [ :description | description at: 'dtype' putType: typeInteger ]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> randomGamma:shapeArray alpha: alpha [ 
	"Outputs random values from a uniform distribution."
	| shape alphaTensor |
	shape := self const: shapeArray asInt32Tensor.
	alphaTensor:= self const: alpha asFloatTensor.

	^ shape op: 'RandomGamma' withAll: {alphaTensor.} named: 'RG' described:
	[:description |]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> randomNormalShaped:shapeArray [
	"Outputs random values from a normal distribution"
	| shape |
	shape := self const: shapeArray asInt32Tensor.
	^ shape unaryOp: 'RandomStandardNormal' described: [:description |
		description at: 'dtype' putType: TFTensor typeFloat]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> randomNormalShaped: shapeArray stddev: aNumber [
	| random |
	random := self randomNormalShaped: shapeArray.
	^ random @* (self const: aNumber asTensor)
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> randomPoisson:shapeArray rate: rate [ 
	"Outputs random values from a uniform distribution."
	| shape  rateTensor |
	shape := self const: shapeArray asInt32Tensor.
	rateTensor:= self const: rate asFloatTensor.

	^ shape op: 'RandomPoissonV2' withAll: {rateTensor.} named: 'RP' described:
	[:description |]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> randomShuffle: aTensor [
	
	| shape |
	shape := self const: aTensor.
	^ shape unaryOp: 'RandomShuffle' described: [:description |]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> randomUniformIntShaped:shapeArray minVal: minTensorAsArray maxVal:maxTensorAsArray [
	"Outputs random values from a uniform distribution."
	| shape mini maxi |
	shape := self const: shapeArray asInt32Tensor.
	mini:= self const: minTensorAsArray asInt32Tensor.
	maxi := self const: maxTensorAsArray  asInt32Tensor.
	^ shape op: 'RandomUniformInt' withAll: {mini. maxi.} named: 'RUI' described:
	[:description |]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> randomUniformShaped:shapeArray [
	"Outputs random values from a uniform distribution."
	| shape |
	shape := self const: shapeArray asInt32Tensor.
	^ shape unaryOp: 'RandomUniform' described: [:description |
		description at: 'dtype' putType: TFTensor typeFloat]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> randomUniformShaped: shapeArray stddev: aNumber [
	| random |
	random := self randomUniformIntShaped: shapeArray.
	^ random @* (self const: aNumber asTensor)
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> runInputs: inArrayOfTFOutputs values: inArrayOfTFTensor outputs: outArrayOfTFOutputs [
	| session |
	session := TFSession on: self.
	self initializeOn: session.
	^ session
		runInputs: inArrayOfTFOutputs
		values: inArrayOfTFTensor
		outputs: outArrayOfTFOutputs
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> truncatedNormalRandomShaped: shapeArray [
	| shape |
	shape := self const: shapeArray asInt32Tensor.
	^ shape
		unaryOp: 'TruncatedNormal'
		described: [ :description | description at: 'dtype' putType: TFTensor typeFloat ]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> truncatedNormalRandomShaped: shapeArray stddev: aNumber [
	| random |
	random := self truncatedNormalRandomShaped: shapeArray.
	^ random @* (self const: aNumber asTensor)
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> variable: nameString forTensor: aTFTensor [
	^ self
		variable: nameString
		type: aTFTensor type
		shape: aTFTensor shape
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> variable: nameString initialValue: aTFTensor [
	| const var |
	var := self variable: nameString forTensor: aTFTensor.
	const := self const: nameString , '_initialValue' value: aTFTensor.
	var assign: const.
	^ var
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> variable: nameString initialValueFrom: aTFOperation [
	| output var shape |
	output := aTFOperation output: 0.
	shape := self shapeOf: output.
	var := self variable: nameString type: output type shape: shape.
	var assign: aTFOperation.
	^ var
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> variable: nameString type: typeInteger shape: anArray [
	^ self
		newOperation: 'Variable'
		named: nameString
		described: [ :description | 
			description
				at: 'dtype' putType: typeInteger;
				at: 'shape' putShape: anArray asTensorShape ]
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFGraph >> zerosShaped: shapeArray [
	"This operation creates a tensor of shape shapeArray and fills it zero"
	
	| shape |
	shape := self const: shapeArray asInt32Tensor.
	^ shape binaryOp: 'Fill' with: 0.0 asTensor
]
