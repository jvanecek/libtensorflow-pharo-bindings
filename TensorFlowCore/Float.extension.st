Extension { #name : #Float }

{ #category : #'*TensorFlowCore' }
Float >> asTensor [
	^ TFTensor fromFloats: self
]
