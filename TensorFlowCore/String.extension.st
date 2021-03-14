Extension { #name : #String }

{ #category : #'*TensorFlowCore' }
String >> asAsciiZ [
	^ self , Character null asString
]

{ #category : #'*TensorFlowCore' }
String >> asTensor [
	^ TFTensor fromString: self
]
