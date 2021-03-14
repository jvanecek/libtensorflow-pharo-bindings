Extension { #name : #ScaledDecimal }

{ #category : #'*TensorFlowCore' }
ScaledDecimal >> asTensor [

	^self asFloatTensor
]
