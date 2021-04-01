Extension { #name : #CategoricalCrossEntropy }

{ #category : #'*TFOperationGradientModel' }
CategoricalCrossEntropy >> partialDerivativeWithRespectTo: aVariable [

	^self partialDerivativeWithRespectTo: aVariable product: self backpropagatedGradient
]

{ #category : #'*TFOperationGradientModel' }
CategoricalCrossEntropy >> partialDerivativeWithRespectTo: aVariable product: aCotangent [

	^Gradient of: logits withRespectTo: aVariable product: aCotangent
]
