Extension { #name : #TensorFlowComputation }

{ #category : #'*TFOperationModel' }
TensorFlowComputation >> constantWith: aNumberOrArray [

	^ConstantNode on: self with: aNumberOrArray asTensor
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
