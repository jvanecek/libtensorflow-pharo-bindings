Extension { #name : #Boolean }

{ #category : #'*TensorFlowCore' }
Boolean >> asBooleanTensor [
	^ TFTensor fromBooleans: self
]

{ #category : #'*TensorFlowCore' }
Boolean >> asTensor [
	^ self asBooleanTensor
]
