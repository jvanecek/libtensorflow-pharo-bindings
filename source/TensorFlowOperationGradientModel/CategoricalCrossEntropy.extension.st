Extension { #name : #CategoricalCrossEntropy }

{ #category : #'*TensorFlowOperationGradientModel' }
CategoricalCrossEntropy >> partialDerivativeWithRespectTo: aVariable [

	^self partialDerivativeWithRespectTo: aVariable product: self backpropagatedGradient
]

{ #category : #'*TensorFlowOperationGradientModel' }
CategoricalCrossEntropy >> partialDerivativeWithRespectTo: aVariable product: aCotangent [

	^Gradient of: logits withRespectTo: aVariable product: aCotangent
]
