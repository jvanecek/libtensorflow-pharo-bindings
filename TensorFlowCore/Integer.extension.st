Extension { #name : #Integer }

{ #category : #'*TensorFlowCore' }
Integer >> asTensor [

	^self asInt32Tensor
]
