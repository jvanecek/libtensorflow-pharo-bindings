Extension { #name : #SparseCategoricalCrossEntropy }

{ #category : #'*TensorFlowOperationGradientModel' }
SparseCategoricalCrossEntropy >> partialDerivativeWithRespectTo: aVariable [

	^self partialDerivativeWithRespectTo: aVariable product: self backpropagatedGradient
]

{ #category : #'*TensorFlowOperationGradientModel' }
SparseCategoricalCrossEntropy >> partialDerivativeWithRespectTo: aVariable product: aCotangent [

	^Gradient of: unscaledLogits withRespectTo: aVariable product: aCotangent
]
