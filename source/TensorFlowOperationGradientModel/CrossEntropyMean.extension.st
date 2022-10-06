Extension { #name : #CrossEntropyMean }

{ #category : #'*TensorFlowOperationGradientModel' }
CrossEntropyMean >> partialDerivativeWithRespectTo: aVariable [

	^crossEntropy partialDerivativeWithRespectTo: aVariable product: self backpropagatedGradient
]
