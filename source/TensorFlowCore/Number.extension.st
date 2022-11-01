Extension { #name : #Number }

{ #category : #'*TensorFlowCore' }
Number >> asFloatTensor [
	^ TFTensor fromFloats: self
]

{ #category : #'*TensorFlowCore' }
Number >> asInt32Tensor [
	^ TFTensor fromInt32s: self
]

{ #category : #'*TensorFlowCore' }
Number >> asInt64Tensor [
	^ TFTensor fromInt64s: self
]

{ #category : #'*TensorFlowCore' }
Number >> asTensor [

	^self subclassResponsibility
]
