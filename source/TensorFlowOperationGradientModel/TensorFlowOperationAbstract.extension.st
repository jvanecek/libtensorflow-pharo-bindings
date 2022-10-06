Extension { #name : #TensorFlowOperationAbstract }

{ #category : #'*TensorFlowOperationGradientModel' }
TensorFlowOperationAbstract >> partialDerivativeWithRespectTo: aVariable [

	^Gradient of: self withRespectTo: aVariable
]

{ #category : #'*TensorFlowOperationGradientModel' }
TensorFlowOperationAbstract >> partialDerivativeWithRespectTo: aVariable product: aCotangent [

	^Gradient of: self withRespectTo: aVariable product: aCotangent
]
