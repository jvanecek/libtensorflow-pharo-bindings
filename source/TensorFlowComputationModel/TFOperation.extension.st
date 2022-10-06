Extension { #name : #TFOperation }

{ #category : #'*TensorFlowComputationModel' }
TFOperation >> castedTo: aType [

	^self castTo: aType
]

{ #category : #'*TensorFlowComputationModel' }
TFOperation >> computeEagerly [

	^graph runOutput: self firstOutput
]

{ #category : #'*TensorFlowComputationModel' }
TFOperation >> currentComputation [

	^TensorFlowComputation on: graph
]

{ #category : #'*TensorFlowComputationModel' }
TFOperation >> operationName [

	^ self name
]

{ #category : #'*TensorFlowComputationModel' }
TFOperation >> outputDimensions [

	^graph outputDimensionsCount: self firstOutput
]

{ #category : #'*TensorFlowComputationModel' }
TFOperation >> outputDomain [

	^TensorDomain of: self outputType withShape: self outputShape
]

{ #category : #'*TensorFlowComputationModel' }
TFOperation >> outputOn: aGraph [

	^self firstOutput
]

{ #category : #'*TensorFlowComputationModel' }
TFOperation >> outputShape [

	^self firstOutput shape
]

{ #category : #'*TensorFlowComputationModel' }
TFOperation >> outputType [

	^self firstOutput type
]
