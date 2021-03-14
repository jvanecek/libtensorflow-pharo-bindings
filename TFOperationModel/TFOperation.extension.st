Extension { #name : #TFOperation }

{ #category : #'*TFOperationModel' }
TFOperation >> castedTo: aType [

	^self castTo: aType
]

{ #category : #'*TFOperationModel' }
TFOperation >> computeEagerly [

	^graph runOutput: self firstOutput
]

{ #category : #'*TFOperationModel' }
TFOperation >> currentComputation [

	^TensorFlowComputation on: graph
]

{ #category : #'*TFOperationModel' }
TFOperation >> operationName [

	^ self name
]

{ #category : #'*TFOperationModel' }
TFOperation >> outputDimensions [

	^graph outputDimensionsCount: self firstOutput
]

{ #category : #'*TFOperationModel' }
TFOperation >> outputDomain [

	^TensorDomain of: self outputType withShape: self outputShape
]

{ #category : #'*TFOperationModel' }
TFOperation >> outputOn: aGraph [

	^self firstOutput
]

{ #category : #'*TFOperationModel' }
TFOperation >> outputShape [

	^self firstOutput shape
]

{ #category : #'*TFOperationModel' }
TFOperation >> outputType [

	^self firstOutput type
]
