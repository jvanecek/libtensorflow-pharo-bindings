Extension { #name : #TensorFlowComputation }

{ #category : #'*TFOperationModel' }
TensorFlowComputation >> constantWith: aNumberOrArray [

	^ConstantNode on: self with: aNumberOrArray asTensor
]

{ #category : #'*TFOperationModel' }
TensorFlowComputation >> createVariableNamed: aName of: aType shaped: aShape initializedWith: aVariableInitializer [ 
	
	| variable | 
	variable := 
		self
			newOperationOf: 'Variable'
			namePrefixed: aName
			withAll: #()
			describedBy: [:description |
				description
					atDataTypePut: aType;
					atShapePut: aShape].
	" If I dont't force the shape with the following collaboration, 
	TF_GraphGetTensorNumDims of a 'Variable' operation returns -1, meaning unknown, although 
	the rank is well knwown. See https://github.com/tensorflow/tensorflow/issues/5106 "
	graph shapeOf: variable firstOutput set: aShape.
	^ variable 
]

{ #category : #'*TFOperationModel' }
TensorFlowComputation >> floatConstantWith: aNumberOrArray [

	^self constantWith: aNumberOrArray asFloatTensor
]

{ #category : #'*TFOperationModel' }
TensorFlowComputation >> floatConstantWith: aNumberOrMatrix named: aName [

	^ConstantNode on: self named: aName with: aNumberOrMatrix asFloatTensor
]

{ #category : #'*TFOperationModel' }
TensorFlowComputation >> floatInputNamed: anInputName [

	^InputNode on: self named: anInputName of: TFTensor typeFloat
]

{ #category : #'*TFOperationModel' }
TensorFlowComputation >> integerConstantWith: aNumberOrArray [

	^self constantWith: aNumberOrArray asInt32Tensor
]

{ #category : #'*TFOperationModel' }
TensorFlowComputation >> integerInputNamed: anInputName [

	^InputNode on: self named: anInputName of: TFTensor typeInt32
]

{ #category : #'*TFOperationModel' }
TensorFlowComputation >> variableNamed: aVariableName with: aTensor [

	^VariableNode on: self named: aVariableName with: aTensor
]
