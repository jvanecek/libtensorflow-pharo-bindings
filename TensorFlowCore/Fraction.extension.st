Extension { #name : #Fraction }

{ #category : #'*TensorFlowCore' }
Fraction >> asTensor [
	^ TFTensor fromFloats: self
]
