Extension { #name : #CrossEntropyMean }

{ #category : #'*TFOperationGradientModel' }
CrossEntropyMean >> partialDerivativeWithRespectTo: aVariable [

	^crossEntropy partialDerivativeWithRespectTo: aVariable product: self backpropagatedGradient
]
