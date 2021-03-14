Extension { #name : #SparseCategoricalCrossEntropy }

{ #category : #'*TFOperationGradientModel' }
SparseCategoricalCrossEntropy >> partialDerivativeWithRespectTo: aVariable [

	^self partialDerivativeWithRespectTo: aVariable product: self backpropagatedGradient
]

{ #category : #'*TFOperationGradientModel' }
SparseCategoricalCrossEntropy >> partialDerivativeWithRespectTo: aVariable product: aCotangent [

	^Gradient of: unscaledLogits withRespectTo: aVariable product: aCotangent
]
