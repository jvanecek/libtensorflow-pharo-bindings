Extension { #name : #TensorFlowOperationAbstract }

{ #category : #'*TFOperationGradientModel' }
TensorFlowOperationAbstract >> partialDerivativeWithRespectTo: aVariable [

	^Gradient of: self withRespectTo: aVariable
]

{ #category : #'*TFOperationGradientModel' }
TensorFlowOperationAbstract >> partialDerivativeWithRespectTo: aVariable product: aCotangent [

	^Gradient of: self withRespectTo: aVariable product: aCotangent
]
